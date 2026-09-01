---
name: perf - 性能优化
title: "[perf]: "
---

## 描述（Description）

<!-- 简述优化的性能问题：哪个操作 / 页面，现状如何 -->

## 基准数据（Baseline）

<!-- 优化前的量化数据（耗时 / 内存 / FPS 等），与优化后对比 -->

| 指标 | 优化前 | 优化后 |
|---|---|---|
| 耗时 | | |
| 内存 | | |
| 其他 | | |

## 类型（Type）

- [ ] **feat** - 新功能
- [ ] **fix** - Bug 修复
- [ ] **chore** - 维护 / 杂项（依赖、配置等）
- [ ] **refactor** - 重构（不改变行为）
- [ ] **docs** - 文档
- [ ] **test** - 测试
- [x] **perf** - 性能优化

## 关联 Issue

<!-- 关闭关联 Issue，例如：Closes #123 -->

Closes #

## 优化方案（Approach）

<!-- 采用什么手段：异步化 / 缓存 / 复用 / 算法改进等 -->

- [ ] 方案 1
- [ ] 方案 2

## 测试计划（Test Plan）

- [ ] `dart analyze` 无 error
- [ ] 按复现方式对比优化前后表现（平台：______）
- [ ] 功能无回归（相关流程走查）

## 截图（Screenshots / Profiling，可选）

<!-- 性能分析截图 / 火焰图等 -->

## 检查清单（Checklist）

- [ ] 代码风格符合项目规范（`dart format`）
- [ ] 无未使用的 import / 依赖
- [ ] 已更新相关文档（README 等，如需要）
- [ ] 提交信息遵循 Conventional Commits（feat / fix / chore 等）
