// Convex Functions for Mission Control

import { mutation, query } from "./_generated/server";
import { v } from "convex/values";

// ========== PROJECTS ==========

export const createProject = mutation({
  args: {
    name: v.string(),
    description: v.optional(v.string()),
    flagship: v.optional(v.boolean()),
    userId: v.string(),
  },
  handler: async (ctx, args) => {
    return await ctx.db.insert("projects", {
      name: args.name,
      description: args.description,
      flagship: args.flagship ?? false,
      status: "active",
      priority: 5,
      createdAt: Date.now(),
      updatedAt: Date.now(),
      userId: args.userId,
    });
  },
});

export const listProjects = query({
  args: { userId: v.string() },
  handler: async (ctx, args) => {
    return await ctx.db
      .query("projects")
      .withIndex("by_user", (q) => q.eq("userId", args.userId))
      .order("desc")
      .collect();
  },
});

export const updateProject = mutation({
  args: {
    id: v.id("projects"),
    name: v.optional(v.string()),
    status: v.optional(v.string()),
    coreLoop: v.optional(v.string()),
    mvu: v.optional(v.string()),
    priority: v.optional(v.number()),
  },
  handler: async (ctx, args) => {
    const { id, ...updates } = args;
    await ctx.db.patch(id, {
      ...updates,
      updatedAt: Date.now(),
    });
  },
});

// ========== IDEAS ==========

export const createIdea = mutation({
  args: {
    text: v.string(),
    scores: v.object({
      impact: v.number(),
      leverage: v.number(),
      momentum: v.number(),
      excitement: v.number(),
      ease: v.number(),
      revenue: v.number(),
      strategic: v.number(),
      automation: v.number(),
    }),
    userId: v.string(),
  },
  handler: async (ctx, args) => {
    const score = Object.values(args.scores).reduce((a, b) => a + b, 0) / 8;
    
    return await ctx.db.insert("ideas", {
      text: args.text,
      scores: args.scores,
      score: score,
      status: "new",
      createdAt: Date.now(),
      userId: args.userId,
    });
  },
});

export const listIdeas = query({
  args: { userId: v.string() },
  handler: async (ctx, args) => {
    return await ctx.db
      .query("ideas")
      .withIndex("by_user", (q) => q.eq("userId", args.userId))
      .order("desc")
      .collect();
  },
});

// ========== REPOS ==========

export const syncRepos = mutation({
  args: {
    repos: v.array(v.any()),
    userId: v.string(),
  },
  handler: async (ctx, args) => {
    let added = 0;
    let updated = 0;

    for (const repo of args.repos) {
      const existing = await ctx.db
        .query("repos")
        .withIndex("by_github_id", (q) => q.eq("githubId", repo.id))
        .first();

      if (existing) {
        await ctx.db.patch(existing._id, {
          name: repo.name,
          fullName: repo.full_name,
          description: repo.description,
          language: repo.language,
          lastCommit: repo.pushed_at,
          githubData: repo,
          updatedAt: Date.now(),
        });
        updated++;
      } else {
        await ctx.db.insert("repos", {
          githubId: repo.id,
          name: repo.name,
          fullName: repo.full_name,
          description: repo.description,
          language: repo.language,
          private: repo.private,
          url: repo.html_url,
          status: "active",
          lastCommit: repo.pushed_at,
          githubData: repo,
          createdAt: Date.now(),
          updatedAt: Date.now(),
          userId: args.userId,
        });
        added++;
      }
    }

    return { added, updated };
  },
});

export const listRepos = query({
  args: { userId: v.string() },
  handler: async (ctx, args) => {
    return await ctx.db
      .query("repos")
      .withIndex("by_user", (q) => q.eq("userId", args.userId))
      .order("desc")
      .take(100);
  },
});

// ========== DOMAINS ==========

export const syncDomains = mutation({
  args: {
    domains: v.array(v.object({
      domain: v.string(),
      status: v.string(),
      project: v.optional(v.string()),
    })),
    userId: v.string(),
  },
  handler: async (ctx, args) => {
    let added = 0;

    for (const domain of args.domains) {
      const existing = await ctx.db
        .query("domains")
        .withIndex("by_domain", (q) => q.eq("domain", domain.domain))
        .first();

      if (!existing) {
        await ctx.db.insert("domains", {
          domain: domain.domain,
          status: domain.status || "parked",
          project: domain.project,
          autoRenew: true,
          createdAt: Date.now(),
          updatedAt: Date.now(),
          userId: args.userId,
        });
        added++;
      }
    }

    return { added };
  },
});

export const listDomains = query({
  args: { userId: v.string() },
  handler: async (ctx, args) => {
    return await ctx.db
      .query("domains")
      .withIndex("by_user", (q) => q.eq("userId", args.userId))
      .collect();
  },
});

// ========== USER STATE ==========

export const getUserState = query({
  args: { userId: v.string() },
  handler: async (ctx, args) => {
    return await ctx.db
      .query("userState")
      .withIndex("by_user", (q) => q.eq("userId", args.userId))
      .first();
  },
});

export const updateUserState = mutation({
  args: {
    userId: v.string(),
    flagship: v.optional(v.string()),
    activeSeed: v.optional(v.any()),
    todayTask: v.optional(v.any()),
    energyLevel: v.optional(v.number()),
  },
  handler: async (ctx, args) => {
    const existing = await ctx.db
      .query("userState")
      .withIndex("by_user", (q) => q.eq("userId", args.userId))
      .first();

    if (existing) {
      await ctx.db.patch(existing._id, {
        ...args,
        lastActive: Date.now(),
      });
    } else {
      await ctx.db.insert("userState", {
        ...args,
        lastActive: Date.now(),
        userId: args.userId,
      });
    }
  },
});

// ========== SYNC ==========

export const getFullSync = query({
  args: { userId: v.string() },
  handler: async (ctx, args) => {
    const [projects, ideas, repos, domains, agents, tasks, userState] = await Promise.all([
      ctx.db.query("projects").withIndex("by_user", (q) => q.eq("userId", args.userId)).collect(),
      ctx.db.query("ideas").withIndex("by_user", (q) => q.eq("userId", args.userId)).collect(),
      ctx.db.query("repos").withIndex("by_user", (q) => q.eq("userId", args.userId)).collect(),
      ctx.db.query("domains").withIndex("by_user", (q) => q.eq("userId", args.userId)).collect(),
      ctx.db.query("agents").withIndex("by_user", (q) => q.eq("userId", args.userId)).collect(),
      ctx.db.query("tasks").withIndex("by_user", (q) => q.eq("userId", args.userId)).collect(),
      ctx.db.query("userState").withIndex("by_user", (q) => q.eq("userId", args.userId)).first(),
    ]);

    return {
      projects,
      ideas,
      repos,
      domains,
      agents,
      tasks,
      userState,
      syncTime: Date.now(),
    };
  },
});
