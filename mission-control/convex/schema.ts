// Convex Schema for Mission Control
// Run: npx convex dev

import { defineSchema, defineTable } from "convex/server";
import { v } from "convex/values";

export default defineSchema({
  // Core entities
  projects: defineTable({
    name: v.string(),
    description: v.optional(v.string()),
    status: v.string(), // active, paused, completed, archived
    flagship: v.boolean(),
    coreLoop: v.optional(v.string()),
    mvu: v.optional(v.string()),
    priority: v.number(),
    createdAt: v.number(),
    updatedAt: v.number(),
    userId: v.string(),
  }).index("by_user", ["userId"])
    .index("by_status", ["userId", "status"]),

  ideas: defineTable({
    text: v.string(),
    score: v.number(),
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
    status: v.string(), // new, reviewed, in-progress, archived
    linkedProject: v.optional(v.id("projects")),
    createdAt: v.number(),
    userId: v.string(),
  }).index("by_user", ["userId"])
    .index("by_score", ["userId", "score"]),

  repos: defineTable({
    githubId: v.number(),
    name: v.string(),
    fullName: v.string(),
    description: v.optional(v.string()),
    language: v.optional(v.string()),
    private: v.boolean(),
    url: v.string(),
    status: v.string(), // active, inactive, archived
    lastCommit: v.optional(v.string()),
    linkedProject: v.optional(v.id("projects")),
    githubData: v.optional(v.any()), // Full GitHub repo data
    createdAt: v.number(),
    updatedAt: v.number(),
    userId: v.string(),
  }).index("by_user", ["userId"])
    .index("by_github_id", ["githubId"]),

  domains: defineTable({
    domain: v.string(),
    status: v.string(), // active, parked, for-sale, expired
    project: v.optional(v.string()),
    registrar: v.optional(v.string()),
    acquiredDate: v.optional(v.number()),
    renewalDate: v.optional(v.number()),
    price: v.optional(v.number()),
    valueEstimate: v.optional(v.number()),
    notes: v.optional(v.string()),
    autoRenew: v.boolean(),
    createdAt: v.number(),
    updatedAt: v.number(),
    userId: v.string(),
  }).index("by_user", ["userId"])
    .index("by_domain", ["domain"])
    .index("by_status", ["userId", "status"]),

  agents: defineTable({
    name: v.string(),
    type: v.string(), // research, content, ops, monitor, integration
    status: v.string(), // active, inactive, dev
    project: v.optional(v.string()),
    description: v.optional(v.string()),
    lastRun: v.optional(v.number()),
    runsCount: v.number(),
    config: v.optional(v.any()),
    createdAt: v.number(),
    updatedAt: v.number(),
    userId: v.string(),
  }).index("by_user", ["userId"])
    .index("by_status", ["userId", "status"]),

  tasks: defineTable({
    text: v.string(),
    assignee: v.string(),
    isAI: v.boolean(),
    completed: v.boolean(),
    completedAt: v.optional(v.number()),
    project: v.optional(v.id("projects")),
    dueDate: v.optional(v.number()),
    priority: v.optional(v.number()),
    createdAt: v.number(),
    userId: v.string(),
  }).index("by_user", ["userId"])
    .index("by_assignee", ["userId", "assignee"]),

  // User state
  userState: defineTable({
    flagship: v.optional(v.string()),
    activeSeed: v.optional(v.object({
      text: v.string(),
      startedAt: v.number(),
    })),
    todayTask: v.optional(v.object({
      text: v.string(),
      date: v.string(),
    })),
    energyLevel: v.optional(v.number()),
    lastActive: v.number(),
    userId: v.string(),
  }).index("by_user", ["userId"]),

  // Sync metadata
  syncMeta: defineTable({
    lastSync: v.number(),
    source: v.string(), // convex, obsidian, github
    entity: v.string(),
    userId: v.string(),
  }).index("by_user", ["userId"]),

  // Obsidian sync tracking
  obsidianVaults: defineTable({
    name: v.string(),
    path: v.string(),
    googleDrivePath: v.optional(v.string()),
    lastSync: v.number(),
    syncEnabled: v.boolean(),
    userId: v.string(),
  }).index("by_user", ["userId"]),
});
