# 项目级 CLAUDE.md 示例

这个文件放在项目根目录，只对当前项目生效。团队成员共享，checkin 到 git。

---

## 项目信息
- 项目名：my-api-server
- 技术栈：Node.js + TypeScript + PostgreSQL + Redis
- 架构：RESTful API，三层架构（controller → service → repository）

## 代码规范
- 使用 ESLint + Prettier，提交前必须通过 lint
- import 顺序：node 内置 → 第三方包 → 本地模块，每组之间空一行
- 接口返回统一格式：`{ code: number, data: T, message: string }`
- 数据库迁移用 Prisma，不要手写 SQL DDL

## 测试要求
- 新增 API 必须附带对应的集成测试
- 测试文件命名：`*.test.ts`，放在 `__tests__/` 目录
- mock 外部服务，不依赖真实网络请求

## 目录结构
```
src/
├── controllers/    # 路由处理，只做参数校验和响应
├── services/       # 业务逻辑
├── repositories/   # 数据库操作
├── middlewares/     # 中间件
├── utils/          # 工具函数
└── types/          # TypeScript 类型定义
```

## 部署相关
- 开发环境：`npm run dev`
- 构建：`npm run build`
- 端口：3000
- 环境变量放 `.env`，不要 commit
