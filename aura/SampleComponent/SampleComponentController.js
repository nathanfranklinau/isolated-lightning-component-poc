({
    init: function(cmp, ev, helper) {
		cmp.set('v.fakeAccounts', [
		    {id: 0, Name: 'Fake Account 0', Phone: '0400 000 000', BillingAddress: '110 Fake St'},
			{id: 1, Name: 'Fake Account 1', Phone: '0400 000 001', BillingAddress: '111 Fake St'},
			{id: 2, Name: 'Fake Account 2', Phone: '0400 000 002', BillingAddress: '112 Fake St'},
			{id: 3, Name: 'Fake Account 3', Phone: '0400 000 003', BillingAddress: '113 Fake St'},
			{id: 4, Name: 'Fake Account 4', Phone: '0400 000 004', BillingAddress: '114 Fake St'}
		]);

		cmp.set('v.fakeAccountColumns', [
			{label: 'ID', fieldName: 'id', type: 'number'},
			{label: 'Name', fieldName: 'Name', type: 'text'},
			{label: 'Phone', fieldName: 'Phone', type: 'phone'},
			{label: 'Address', fieldName: 'BillingAddress', type: 'text'}
		]);

		setTimeout($A.getCallback(function() {
		    var appEvent = $A.get('e.c:SampleComponentEvent');
		    appEvent.setParam('param1', 'Parameter 1!!');
		    appEvent.fire();
  		}));
    }
})