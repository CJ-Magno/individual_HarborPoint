<template>
	<div class="flex min-h-full flex-col bg-surface-base">
		<header class="flex items-center justify-between border-b px-6 py-4">
			<div>
				<p class="text-sm text-ink-gray-5">HarborPoint Learning Solutions</p>
				<h1 class="text-xl font-semibold text-ink-gray-9">IT Asset Management</h1>
			</div>
			<div class="flex items-center gap-2">
				<span class="rounded-full bg-surface-green-2 px-3 py-1 text-sm text-ink-green-3">
					AS-IS baseline
				</span>
				<button
					class="rounded-md bg-surface-gray-7 px-3 py-2 text-sm text-white hover:bg-surface-gray-8"
					@click="showIntake = !showIntake"
				>
					{{ showIntake ? 'Close intake' : 'Record intake' }}
				</button>
			</div>
		</header>

		<main class="flex flex-1 flex-col gap-6 overflow-auto p-6">
			<section class="grid grid-cols-1 gap-3 md:grid-cols-2 xl:grid-cols-4">
				<div v-for="metric in metrics" :key="metric.label" class="rounded-lg border bg-surface-white p-4">
					<p class="text-sm text-ink-gray-5">{{ metric.label }}</p>
					<p class="mt-2 text-2xl font-semibold text-ink-gray-9">{{ metric.value }}</p>
					<p class="mt-1 text-xs text-ink-gray-5">{{ metric.detail }}</p>
				</div>
			</section>

			<section v-if="showIntake" class="rounded-lg border bg-surface-white p-5">
				<div class="mb-4 flex items-center justify-between">
					<div>
						<h2 class="font-semibold text-ink-gray-9">Asset intake checklist</h2>
						<p class="text-sm text-ink-gray-5">Centralize receipt, tagging, and Freshservice registration.</p>
					</div>
					<span class="text-sm text-ink-orange-3">3 steps pending</span>
				</div>
				<div class="grid gap-3 md:grid-cols-3">
					<div v-for="step in intakeSteps" :key="step" class="rounded-md bg-surface-gray-1 p-3 text-sm text-ink-gray-7">
						<span class="mr-2 inline-block h-2 w-2 rounded-full bg-surface-orange-3"></span>{{ step }}
					</div>
				</div>
			</section>

			<section class="grid gap-6 xl:grid-cols-[1.4fr_1fr]">
				<div class="rounded-lg border bg-surface-white p-5">
					<div class="mb-4 flex items-center justify-between">
						<div>
							<h2 class="font-semibold text-ink-gray-9">Asset lifecycle</h2>
							<p class="text-sm text-ink-gray-5">The current AS-IS process mapped to the proposed control points.</p>
						</div>
						<span class="text-xs text-ink-gray-5">280 employees · 24 IT staff</span>
					</div>
					<div class="grid gap-3 md:grid-cols-2">
						<div
							v-for="(stage, index) in lifecycle"
							:key="stage.name"
							class="rounded-md border p-4"
							:class="stage.risk ? 'border-surface-orange-3 bg-surface-orange-1' : 'border-outline-gray-2'"
						>
							<div class="flex items-center justify-between">
								<span class="text-xs font-medium text-ink-gray-5">0{{ index + 1 }}</span>
								<span v-if="stage.risk" class="text-xs text-ink-orange-3">Gap identified</span>
							</div>
							<h3 class="mt-2 font-medium text-ink-gray-9">{{ stage.name }}</h3>
							<p class="mt-1 text-sm text-ink-gray-6">{{ stage.asIs }}</p>
							<p class="mt-3 text-xs text-ink-green-3">To-be: {{ stage.toBe }}</p>
						</div>
					</div>
				</div>

				<div class="rounded-lg border bg-surface-white p-5">
					<div class="mb-4">
						<h2 class="font-semibold text-ink-gray-9">Priority pain points</h2>
						<p class="text-sm text-ink-gray-5">Risks surfaced from the AS-IS assessment.</p>
					</div>
					<div class="flex flex-col gap-3">
						<div v-for="point in painPoints" :key="point.id" class="flex gap-3">
							<span class="mt-0.5 rounded bg-surface-red-2 px-2 py-0.5 text-xs font-medium text-ink-red-3">
								{{ point.id }}
							</span>
							<div>
								<p class="text-sm font-medium text-ink-gray-8">{{ point.title }}</p>
								<p class="text-xs text-ink-gray-5">{{ point.detail }}</p>
							</div>
						</div>
					</div>
				</div>
			</section>

			<section class="rounded-lg border bg-surface-white p-5">
				<div class="mb-4 flex items-center justify-between">
					<div>
						<h2 class="font-semibold text-ink-gray-9">Asset register</h2>
						<p class="text-sm text-ink-gray-5">Use this view to validate custody, location, and lifecycle status.</p>
					</div>
					<select v-model="statusFilter" class="rounded-md border bg-surface-white px-3 py-2 text-sm text-ink-gray-7">
						<option value="All">All statuses</option>
						<option value="Assigned">Assigned</option>
						<option value="Repair">Repair</option>
						<option value="Loaner">Loaner</option>
						<option value="Retirement">Retirement</option>
					</select>
				</div>
				<div class="overflow-x-auto">
					<table class="w-full min-w-[680px] text-left text-sm">
						<thead class="border-b text-xs uppercase text-ink-gray-5">
							<tr>
								<th class="px-3 py-3 font-medium">Asset</th>
								<th class="px-3 py-3 font-medium">Type</th>
								<th class="px-3 py-3 font-medium">Custodian</th>
								<th class="px-3 py-3 font-medium">Location</th>
								<th class="px-3 py-3 font-medium">Status</th>
								<th class="px-3 py-3 font-medium">Next action</th>
							</tr>
						</thead>
						<tbody>
							<tr v-for="asset in filteredAssets" :key="asset.id" class="border-b last:border-0">
								<td class="px-3 py-3 font-medium text-ink-gray-8">{{ asset.id }}</td>
								<td class="px-3 py-3 text-ink-gray-6">{{ asset.type }}</td>
								<td class="px-3 py-3 text-ink-gray-6">{{ asset.custodian }}</td>
								<td class="px-3 py-3 text-ink-gray-6">{{ asset.location }}</td>
								<td class="px-3 py-3">
									<span class="rounded-full px-2 py-1 text-xs" :class="statusClass(asset.status)">
										{{ asset.status }}
									</span>
								</td>
								<td class="px-3 py-3 text-ink-gray-6">{{ asset.nextAction }}</td>
							</tr>
						</tbody>
					</table>
				</div>
			</section>
		</main>
	</div>
</template>

<script setup lang="ts">
import { computed, ref } from 'vue'

const showIntake = ref(false)
const statusFilter = ref('All')

const metrics = [
	{ label: 'Tracked assets', value: '1,248', detail: 'Laptops, desktops, mobile devices, and peripherals' },
	{ label: 'Pending intake', value: '18', detail: 'Received but not yet fully registered' },
	{ label: 'Loaners due soon', value: '7', detail: 'Return dates require follow-up' },
	{ label: 'Renewals this quarter', value: '12', detail: 'License and warranty renewal dates' },
]

const intakeSteps = ['Confirm delivery and serial number', 'Apply asset tag and assign owner', 'Register receipt and evidence']

const lifecycle = [
	{ name: 'Procurement and intake', asIs: 'Manual entry after delivery; approvals use email.', toBe: 'Centralized receipt and approval workflow.', risk: true },
	{ name: 'Assignment and check-out', asIs: 'Requests and handoff are linked, but acceptance varies.', toBe: 'Required digital acceptance before closure.', risk: true },
	{ name: 'Movement and transfer', asIs: 'Locations and loaners are updated manually.', toBe: 'Transfer rules and return dates are enforced.', risk: true },
	{ name: 'Maintenance and repair', asIs: 'Diagnostics, warranty checks, and updates are inconsistent.', toBe: 'Standard checks and complete repair history.', risk: true },
	{ name: 'Software licensing', asIs: 'Availability and renewals rely partly on reminders.', toBe: 'Automated lifecycle and renewal alerts.', risk: true },
	{ name: 'Retirement and disposal', asIs: 'Disposal and erasure evidence is stored separately.', toBe: 'One asset record with auditable evidence.', risk: true },
]

const painPoints = [
	{ id: 'P1', title: 'Delayed intake visibility', detail: 'Assets can remain unregistered for several days after delivery.' },
	{ id: 'P4', title: 'Missing digital acceptance', detail: 'Equipment may be released before accountability is complete.' },
	{ id: 'P6', title: 'Loaner tracking gap', detail: 'Separate tracking makes return dates difficult to monitor.' },
	{ id: 'P9', title: 'Renewal dependency', detail: 'License renewals partly depend on personal calendar reminders.' },
	{ id: 'P10', title: 'Erasure evidence gap', detail: 'Data-erasure proof is stored outside the asset record.' },
]

const assets = [
	{ id: 'HPL-LT-0042', type: 'Laptop', custodian: 'Maria Santos', location: 'Calapan HQ', status: 'Assigned', nextAction: 'Review in 90 days' },
	{ id: 'HPL-LT-0088', type: 'Laptop', custodian: 'IT Service Desk', location: 'Batangas Branch', status: 'Loaner', nextAction: 'Return due 12 Aug' },
	{ id: 'HPL-DT-0131', type: 'Desktop', custodian: 'Jose Dela Cruz', location: 'Quezon City Office', status: 'Repair', nextAction: 'Warranty check' },
	{ id: 'HPL-TB-0027', type: 'Tablet', custodian: 'Unassigned', location: 'Calapan Warehouse', status: 'Retirement', nextAction: 'Attach erasure evidence' },
]

const filteredAssets = computed(() =>
	statusFilter.value === 'All' ? assets : assets.filter((asset) => asset.status === statusFilter.value),
)

function statusClass(status: string) {
	return {
		Assigned: 'bg-surface-green-2 text-ink-green-3',
		Repair: 'bg-surface-orange-2 text-ink-orange-3',
		Loaner: 'bg-surface-blue-2 text-ink-blue-3',
		Retirement: 'bg-surface-red-2 text-ink-red-3',
	}[status]
}
</script>
