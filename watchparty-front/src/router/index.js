import Vue from 'vue'
import Router from 'vue-router'
import Signin from '@/components/Signin.vue'
import Signup from '@/components/Signup.vue'
import Room from '@/components/rooms/Room.vue'
import RoomAccess from '@/components/rooms/RoomAccess.vue'
import RoomVideo from '@/components/rooms/RoomVideo.vue'

Vue.use(Router)

export default new Router({
  mode: 'history',
  routes: [
    {
      path: '/rooms',
      name: 'Room',
      component: Room
    },
    {
      path: '/rooms/:id',
      name: 'RoomVideo',
      component: RoomVideo
    },
    {
      path: '/rooms/:id/access/:accessCode',
      name: 'RoomAccess',
      component: RoomAccess
    },
    {
      path: '/',
      name: 'Signin',
      component: Signin
    },
    {
      path: '/signup',
      name: 'Signup',
      component: Signup
    }
  ]
})
