import { createRouter, createWebHistory } from 'vue-router'
import About from '@/pages/About.vue'
import Home from '@/pages/Home.vue'
//@ts-ignore
import CreateRepository from '@/pages/CreateRepository.vue'

const router = createRouter({
  history: createWebHistory(import.meta.env.BASE_URL),
  routes: [
    {
      path: '/',
      name: 'home',
      component: Home
    },
    {
      path: '/about',
      name: 'about',
      component: About
    },
    {
      path: '/repositories',
      name: 'repositories',
      // @ts-ignore
      component: () => import('@/pages/Repositories.vue')
    },
    {
      path: '/repo/:r',
      //@ts-ignore
      component: () => import('@/pages/Repository.vue')
    },
    {
      path: '/create/repo',
      component: CreateRepository
    }
  ]
})

export default router
