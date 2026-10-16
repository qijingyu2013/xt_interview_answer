import { defineStore } from 'pinia'
import { ref, computed } from 'vue'
import { authApi } from '@/api'

export const useDepartmentStore = defineStore('department', () => {
  const token = ref<string | null>(localStorage.getItem('token'))
  const departmentInfo = ref<any>(null)

  const isLoggedIn = computed(() => !!token.value)

  function setToken(newToken: string) {
    token.value = newToken
    localStorage.setItem('token', newToken)
  }

  function setDepartmentInfo(info: any) {
    departmentInfo.value = info
  }

  function logout() {
    token.value = null
    departmentInfo.value = null
    localStorage.removeItem('token')
    localStorage.removeItem('department')
  }

  async function validateToken() {
    if (!token.value) return { valid: false }
    try {
      const res: any = await authApi.validate()
      return res
    } catch (e) {
      console.error('Token验证失败', e)
      return { valid: false }
    }
  }

  function loadFromStorage() {
    const stored = localStorage.getItem('currentUser')
    if (stored) {
      departmentInfo.value = JSON.parse(stored)
    }
  }

  return {
    token,
    departmentInfo,
    isLoggedIn,
    setToken,
    setDepartmentInfo,
    logout,
    validateToken,
    loadFromStorage
  }
})
