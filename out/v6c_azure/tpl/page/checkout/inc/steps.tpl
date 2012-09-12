[{*--
  * SUMMARY OF V6C MODS:
  *		Handle step numbering here instead of with lang files
  *		Add support for old XprsChkOut steps
  *			- remove payment step
  *			- remove step numbering
  *			- increase size of done list-item
  *		Change Options step to Paymant step for XprsChkOut
--*}]

[{block name="checkout_steps_main"}]
    <ul class="checkoutSteps clear">
        [{if $oxcmp_basket->getProductsCount() }]
            [{assign var=showStepLinks value=true}]
        [{/if}]

        [{block name="checkout_steps_basket"}]
            <li class="step1[{ if $active == 1}] active [{elseif $active > 1}] passed [{/if}][{if $oViewConf->v6cIsOldXprsStps()}] v6c_xprs [{/if}]">
                <span>
                    [{if $showStepLinks}]<a rel="nofollow" href="[{ oxgetseourl ident=$oViewConf->getBasketLink() }]">[{/if}]
                    [{ oxmultilang ident="PAGE_CHECKOUT_STEPS_BASKET" }]
                    [{if $showStepLinks}]</a>[{/if}]
                </span>
            </li>
        [{/block}]

        [{assign var=showStepLinks value=false}]
        [{if !$oView->isLowOrderPrice() && $oxcmp_basket->getProductsCount() }]
            [{assign var=showStepLinks value=true}]
        [{/if}]

        [{block name="checkout_steps_send"}]
            <li class="step2[{ if $active == 2}] active [{elseif $active > 2}] passed [{/if}][{if $oViewConf->v6cIsOldXprsStps()}] v6c_xprs [{/if}]">
                <span>
                    [{if $showStepLinks}]<a rel="nofollow" href="[{ oxgetseourl ident=$oViewConf->getOrderLink() }]">[{/if}]
                    [{if !$oViewConf->v6cIsOldXprsStps()}]1.&nbsp;[{/if}][{ oxmultilang ident="PAGE_CHECKOUT_STEPS_SEND" }]
                    [{if $showStepLinks}]</a>[{/if}]
                </span>
            </li>
        [{/block}]

		[{if !$oViewConf->v6cIsOldXprsStps()}]
	        [{assign var=showStepLinks value=false}]
	        [{if $active != 1 && $oxcmp_user && !$oView->isLowOrderPrice() && $oxcmp_basket->getProductsCount() }]
	            [{assign var=showStepLinks value=true}]
	        [{/if}]


	        [{block name="checkout_steps_pay"}]
	            <li class="step3[{ if $active == 3}] active [{elseif $active > 3}] passed [{/if}]">
	                <span>
	                    [{if $showStepLinks}]<a rel="nofollow" [{if $oViewConf->getActiveClassName() == "user"}]id="paymentStep"[{/if}] href="[{ oxgetseourl ident=$oViewConf->getPaymentLink() }]">[{/if}]
	                    2.&nbsp;[{if $oViewConf->v6cIsXprsChkOut()}][{ oxmultilang ident="V6C_STEPS_PAY" }][{else}][{ oxmultilang ident="PAGE_CHECKOUT_STEPS_PAY" }][{/if}]
	                    [{if $showStepLinks}]</a>[{/if}]
	                </span>
	            </li>
	        [{/block}]
		[{/if}]

        [{assign var=showStepLinks value=false}]
        [{if $active != 1 && $oxcmp_user && $oxcmp_basket->getProductsCount() && $oView->getPaymentList() && !$oView->isLowOrderPrice()}]
            [{assign var=showStepLinks value=true}]
        [{/if}]

        [{block name="checkout_steps_order"}]
            <li class="step4[{ if $active == 4}] active [{elseif $active > 4}] passed [{/if}][{if $oViewConf->v6cIsOldXprsStps()}] v6c_xprs [{/if}]">
                <span>
                    [{if $showStepLinks}]<a rel="nofollow" [{if $oViewConf->getActiveClassName() == "payment"}]id="orderStep"[{/if}] href="[{ if $oViewConf->getActiveClassName() == "payment"}]javascript:document.forms.order.submit();[{else}][{ oxgetseourl ident=$oViewConf->getOrderConfirmLink() }][{/if}]">[{/if}]
                    [{if !$oViewConf->v6cIsOldXprsStps()}]3.&nbsp;[{/if}][{ oxmultilang ident="PAGE_CHECKOUT_STEPS_ORDER" }]
                    [{if $showStepLinks}]</a>[{/if}]
                </span>
            </li>
        [{/block}]

        [{block name="checkout_steps_laststep"}]
            <li class="step5[{ if $active == 5}] activeLast [{else}] defaultLast [{/if}][{if $oViewConf->v6cIsOldXprsStps()}] v6c_xprs [{/if}]">
                <span>
                    [{ oxmultilang ident="PAGE_CHECKOUT_STEPS_LASTSTEP" }]
                </span>
            </li>
        [{/block}]
    </ul>
[{/block}]