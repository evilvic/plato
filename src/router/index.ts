import { createRouter, createWebHistory } from 'vue-router'
import DiaryView from '@/views/DiaryView.vue'

const router = createRouter({
  history: createWebHistory(import.meta.env.BASE_URL),
  routes: [
    {
      path: '/',
      name: 'diary',
      component: DiaryView
    },
  ]
})

export default router
