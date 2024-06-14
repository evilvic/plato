import { createRouter, createWebHistory } from 'vue-router'
// import authService from '@/helpers/authService'
import publicRoutes from '@/router/publicRoutes'
import DiaryView from '@/views/DiaryView.vue'
import NewMenuView from '@/views/NewMenuView.vue'
import FoodRecordView from '@/views/FoodRecordView.vue'
import WaterRecordView from '@/views/WaterRecordView.vue'
import WeightRecordView from '@/views/WeightRecordView.vue'

const router = createRouter({
  history: createWebHistory(import.meta.env.BASE_URL),
  routes: [
    ...publicRoutes,
    {
      path: '/',
      name: 'diary',
      component: DiaryView,
      meta: {
        requiresAuth: true
      }
    },
    {
      path: '/new',
      name: 'new',
      component: NewMenuView,
      meta: {
        requiresAuth: true
      }
    },
    {
      path: '/food',
      name: 'food',
      component: FoodRecordView,
      meta: {
        requiresAuth: true
      }
    },
    {
      path: '/water',
      name: 'water',
      component: WaterRecordView,
      meta: {
        requiresAuth: true
      }
    },
    {
      path: '/weight',
      name: 'weight',
      component: WeightRecordView,
      meta: {
        requiresAuth: true
      }
    },
  ]
})

// router.beforeEach(async (to, from, next) => {
//   if (to.matched.some(record => record.meta.requiresAuth)) {
//     const isAuthenticated = await authService.isAuthenticated()
//     if (!isAuthenticated) {
//       next({ path: '/login' });
//     } else {
//       next();
//     }
//   } else {
//     next();
//   }
// })

export default router
