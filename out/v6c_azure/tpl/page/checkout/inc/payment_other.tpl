[{*--
  * SUMMARY OF V6C MODS:
  *		Remove all occurences of currency sign: $currency->sign
  * SUMMARY OF v6cMerchantLink MODS:
  *		WIP: Detect if linked merchant payment has already been authorized and, if so, give user option to user existing info or submit new info.
--*}]

[{*if $oView->getCheckedPaymentId() == $paymentmethod->oxpayments__oxid->value && $paymentmethod->v6cIsLinkedGateway() && $paymentmethod->v6cGetGatewayLinkType() == 1 && $oView->v6cHaveLnkPayInfo()}]
	[{assign var='v6c_aloop' value=','|explode:"1,2"}]
	<input type="hidden" name="v6c_lnkpaydone" id="v6c_lnkpaydone" value="true" />
[{else*}]
	[{assign var='v6c_aloop' value=','|explode:"1"}]
[{*/if*}]
[{foreach from=$v6c_aloop item=v6c_loop}]
	<dl>
	    <dt>
	        <input id="payment_[{$sPaymentID}]" type="radio" name="paymentid" value="[{$sPaymentID}]" [{if $oView->getCheckedPaymentId() == $paymentmethod->oxpayments__oxid->value && $v6c_loop == 1}]checked[{/if}] [{if count($v6c_aloop) == 2}]onclick="[{if $v6c_loop == 1}]document.getElementById('v6c_lnkpaydone').value = 'true';[{else}]document.getElementById('v6c_lnkpaydone').value = 'false';[{/if}]"[{/if}]>
	        <label for="payment_[{$sPaymentID}]"><b>[{ $paymentmethod->oxpayments__oxdesc->value}][{if count($v6c_aloop) == 2}] [{if $v6c_loop == 1}](No Changes)[{else}](Change Details)[{/if}][{/if}] [{ if $paymentmethod->fAddPaymentSum }]([{ $paymentmethod->fAddPaymentSum }] [{ $currency->sign}])[{/if}]</b></label>
	    </dt>
	    <dd class="[{if $oView->getCheckedPaymentId() == $paymentmethod->oxpayments__oxid->value}]activePayment[{/if}]">
	        <ul>
	        [{foreach from=$paymentmethod->getDynValues() item=value name=PaymentDynValues}]
	            <li>
	                <label>[{ $value->name}]</label>
	                <input id="[{$sPaymentID}]_[{$smarty.foreach.PaymentDynValues.iteration}]" type="text" class="textbox" size="20" maxlength="64" name="dynvalue[[{$value->name}]]" value="[{ $value->value}]">
	            </li>
	        [{/foreach}]
	        </ul>

	        [{block name="checkout_payment_longdesc"}]
	            [{if $paymentmethod->oxpayments__oxlongdesc->value}]
	                <div class="desc"[{if count($v6c_aloop) == 2 && $v6c_loop == 2}] style="display: none;"[{/if}]>
	                    [{ $paymentmethod->oxpayments__oxlongdesc->value}]
	                </div>
	            [{/if}]
	        [{/block}]
	    </dd>
	</dl>
[{/foreach}]