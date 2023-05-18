<template>
  <div class="signup-container">
    <div class="signup-form">
      <h3 class="title">Cadastre-se</h3>
      <form @submit.prevent="signup" class="form">
        <div v-if="error" class="error">{{ error }}</div>
        <div class="form-group">
          <label for="email" class="label">E-mail</label>
          <input type="email" v-model="email" class="input" id="email" placeholder="seuemail@gmail.com">
        </div>
        <div class="form-group">
          <label for="password" class="label">Senha</label>
          <input type="password" v-model="password" class="input" id="password" placeholder="senha">
        </div>
        <div class="form-group">
          <label for="password_confirmation" class="label">Confirme sua senha</label>
          <input type="password" v-model="password_confirmation" class="input" id="password_confirmation"
            placeholder="confirme sua senha">
        </div>
        <button type="submit" class="submit-button">Cadastrar</button>
        <div class="login-link"><router-link to="/">Já possui conta?</router-link></div>
      </form>
    </div>
  </div>
</template>

<script>
export default {
  name: 'Signup',
  data () {
    return {
      email: '',
      password: '',
      password_confirmation: '',
      error: ''
    }
  },
  created () {
    this.checkedSignedIn()
  },
  updated () {
    this.checkedSignedIn()
  },
  methods: {
    signup () {
      this.$httpPlain.post('/signup', { email: this.email, password: this.password, password_confirmation: this.password_confirmation })
        .then(response => this.signupSuccessful(response))
        .catch(error => this.signupFailed(error))
    },
    signupSuccessful (response) {
      if (!response.data.csrf) {
        this.signupFailed(response)
        return
      }

      localStorage.csrf = response.data.csrf
      localStorage.signedIn = true
      this.error = ''
      window.location.reload()
    },
    signupFailed (error) {
      this.error = (error.response && error.response.data && error.response.data.error) || 'Something went wrong'
      delete localStorage.csrf
      delete localStorage.signedIn
    },
    checkedSignedIn () {
      if (localStorage.signedIn) {
        this.$router.replace('/rooms')
      }
    }
  }
}
</script>

<style scoped>
.signup-container {
  display: flex;
  justify-content: center;
  align-items: center;
}

.form-group {
  margin-top: 15px;
}

.signup-form {
  min-width: 400px;
  max-width: 400px;
  padding: 20px;
  background-color: #f0f0f0;
  border-radius: 5px;
}

.title {
  font-size: 24px;
  margin-bottom: 20px;
}

.form {
  margin-bottom: 20px;
}

.error {
  color: red;
  margin-bottom: 10px;
}

.label {
  font-weight: bold;
  margin-bottom: 5px;
}

.input {
  padding: 5px;
  width: 100%;
  border-radius: 3px;
  border: 1px solid #ccc;
}

.submit-button {
  background-color: #1e6711;
  color: #fff;
  padding: 10px 20px;
  margin: 14px 1px -5px 1px;
  border: none;
  border-radius: 3px;
  cursor: pointer;
}

.login-link {
  margin-top: 10px;
}

.login-link a {
  color: #1e6711;
  text-decoration: none;
  font-size: 12px;
  margin: 3px;
}
</style>
