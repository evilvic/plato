export default [
  {
    path: '/login',
    name: 'login',
    component: () => import('@/views/LoginView.vue')
  },
  {
    path: '/otp',
    name: 'otp',
    component: () => import('@/views/OtpView.vue')
  }
]