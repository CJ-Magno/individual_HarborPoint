<template>
	<div class="flex min-h-screen flex-col items-center justify-center bg-surface-gray-1">
		<div class="w-full max-w-sm rounded-2xl border bg-surface-white p-8 shadow-xl">
			<!-- Branding -->
			<div class="mb-6 text-center">
				<div
					class="mx-auto mb-4 flex h-14 w-14 items-center justify-center rounded-full"
					style="background: #1d4ed8"
				>
					<span class="text-2xl font-bold text-white">HP</span>
				</div>
				<h1 class="text-xl font-bold text-ink-gray-9">HarborPoint Learning Solutions</h1>
				<p class="mt-1 text-sm text-ink-gray-5">IT Asset Management System</p>
			</div>

			<form @submit.prevent="handleLogin" class="flex flex-col gap-4">
				<FormControl
					label="Username or Email"
					placeholder="Administrator"
					v-model="email"
					name="email"
					autocomplete="username email"
					:type="email !== 'Administrator' ? 'email' : 'text'"
					required
				/>
				<FormControl
					label="Password"
					type="password"
					placeholder="••••••"
					v-model="password"
					name="password"
					autocomplete="current-password"
					required
				/>
				<div
					v-if="errorMessage"
					class="rounded-md border border-surface-red-3 bg-surface-red-1 p-3 text-sm text-ink-red-3"
				>
					{{ errorMessage }}
				</div>
				<Button
					class="mt-1"
					variant="solid"
					:disabled="loggingIn"
					:loading="loggingIn"
					@click="handleLogin"
				>
					Sign in to HarborPoint
				</Button>
			</form>

			<div class="mt-6 border-t pt-4 text-center text-xs text-ink-gray-4">
				<p>Calapan City, Oriental Mindoro, Philippines</p>
				<p class="mt-1">© 2024 HarborPoint Learning Solutions</p>
			</div>
		</div>
	</div>
</template>

<script setup lang="ts">
import { ref } from 'vue'
import { call } from 'frappe-ui'
import { APP_PATH } from '../app_path'

const email = ref('Administrator')
const password = ref('')
const errorMessage = ref('')
const loggingIn = ref(false)

async function handleLogin() {
	if (!email.value || !password.value) return
	try {
		errorMessage.value = ''
		loggingIn.value = true
		await call('login', { usr: email.value, pwd: password.value })
		window.location.assign(APP_PATH + '/harborpoint-assets')
	} catch (err: any) {
		errorMessage.value = err?.messages?.join('\n') ?? 'Invalid credentials. Please try again.'
		loggingIn.value = false
	}
}
</script>
