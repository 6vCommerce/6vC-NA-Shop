[{*--
  * SUMMARY OF V6C_NA MODS:
  *		Remove all occurences of currency sign: $currency->sign
  *		Repeat mods done to basketcontents.tpl for order page price summary with the following differences:
  *			- Leave greeting card after article list
  *			- Adjust borders here since they are not handled by css
  *			- Corrected misuse of getFVoucherDiscountValue in condition requiring unformatted value.
  *			- Remove hardcoded colons after some cost labels.
  *		Replace local address layout with address widgets.
  *		Move user VAT/Tax ID to after address info
--*}]

[{ assign var="shop"      value=$oEmailView->getShop() }]
[{ assign var="oViewConf" value=$oEmailView->getViewConfig() }]
[{ assign var="oConf"     value=$oViewConf->getConfig() }]
[{ assign var="currency"  value=$oEmailView->getCurrency() }]
[{ assign var="user"      value=$oEmailView->getUser() }]
[{ assign var="basket"    value=$order->getBasket() }]
[{ assign var="oDelSet"   value=$order->getDelSet() }]
[{ assign var="payment"   value=$order->getPayment() }]

[{include file="email/html/header.tpl" title=$shop->oxshops__oxordersubject->value}]

        [{block name="email_html_order_owner_orderemail"}]
            <p style="font-family: Arial, Helvetica, sans-serif; font-size: 12px; margin: 0; padding: 10px 0;">
                [{if $payment->oxuserpayments__oxpaymentsid->value == "oxempty"}]
                    [{oxcontent ident="oxadminordernpemail"}]
                [{else}]
                    [{oxcontent ident="oxadminorderemail"}]
                [{/if}]

                [{ oxmultilang ident="EMAIL_ORDER_CUST_HTML_ORDERNOMBER" }] <b>[{ $order->oxorder__oxordernr->value }]</b>
            </p>
        [{/block}]

            <table border="0" cellspacing="0" cellpadding="0" width="100%">
                <tr>
                    <td height="15" width="100" style="padding: 5px; border-bottom: 4px solid #ddd;">
                        <p style="font-family: Arial, Helvetica, sans-serif; font-size: 12px; margin: 0; padding: 0;"><b>[{ oxmultilang ident="EMAIL_ORDER_CUST_HTML_PRODUCT" }]</b></p>
                    </td>
                    <td style="padding: 5px; border-bottom: 4px solid #ddd;">
                        &nbsp;
                    </td>
                    <td style="padding: 5px; border-bottom: 4px solid #ddd;">
                        <p style="font-family: Arial, Helvetica, sans-serif; font-size: 12px; margin: 0; padding: 0;"><b>[{ oxmultilang ident="EMAIL_ORDER_CUST_HTML_QUANTITY" }]</b></p>
                    </td>
                    <td style="padding: 5px; border-bottom: 4px solid #ddd;">
                        <p style="font-family: Arial, Helvetica, sans-serif; font-size: 12px; margin: 0; padding: 0;"><b>[{ oxmultilang ident="EMAIL_ORDER_CUST_HTML_UNITPRICE" }]</b></p>
                    </td>
                    [{*<td style="padding: 5px; border-bottom: 4px solid #ddd;">
                        <p style="font-family: Arial, Helvetica, sans-serif; font-size: 12px; margin: 0; padding: 0;"><b>[{ oxmultilang ident="EMAIL_ORDER_CUST_HTML_VAT" }]</b></p>
                    </td>*}]
                    <td style="padding: 5px; border-bottom: 4px solid #ddd;">
                        <p style="font-family: Arial, Helvetica, sans-serif; font-size: 12px; margin: 0; padding: 0;"><b>[{ oxmultilang ident="EMAIL_ORDER_CUST_HTML_TOTAL" }]</b></p>
                    </td>
                </tr>
                [{assign var="basketitemlist" value=$basket->getBasketArticles() }]
                [{foreach key=basketindex from=$basket->getContents() item=basketitem}]
                    [{block name="email_html_order_owner_basketitem"}]
                        [{assign var="basketproduct" value=$basketitemlist.$basketindex }]
                        <tr valign="top">
                            <td style="padding: 5px; border-bottom: 4px solid #ddd;">
                                <img src="[{$basketproduct->getThumbnailUrl(false) }]" border="0" hspace="0" vspace="0" alt="[{$basketitem->getTitle()|strip_tags}]" align="texttop">
                                [{if $oViewConf->getShowGiftWrapping() }]
                                <p style="font-family: Arial, Helvetica, sans-serif; font-size: 12px; margin: 0; padding: 10px 0;">
                                    [{assign var="oWrapping" value=$basketitem->getWrapping() }]
                                    <b>[{ oxmultilang ident="EMAIL_ORDER_CUST_HTML_WRAPPING" }]&nbsp;</b>[{ if !$basketitem->getWrappingId() }][{ oxmultilang ident="EMAIL_ORDER_CUST_HTML_NONE" }][{else}][{$oWrapping->oxwrapping__oxname->value}][{/if}]
                                </p>
                                [{/if}]
                            </td>
                            <td style="padding: 5px; border-bottom: 4px solid #ddd;">
                                <p style="font-family: Arial, Helvetica, sans-serif; font-size: 12px; margin: 0; padding: 10px 0;">
                                    <b>[{$basketitem->getTitle()}]</b>
                                    [{ if $basketitem->getChosenSelList() }],
                                    [{foreach from=$basketitem->getChosenSelList() item=oList}]
                                    [{ $oList->name }] [{ $oList->value }]&nbsp;
                                    [{/foreach}]
                                    [{/if}]
                                    [{ if $basketitem->getPersParams() }]
                                    [{foreach key=sVar from=$basketitem->getPersParams() item=aParam}]
                                    ,&nbsp;<em>[{$sVar}] : [{$aParam}]</em>
                                    [{/foreach}]
                                    [{/if}]
                                    <br>[{ oxmultilang ident="EMAIL_ORDER_CUST_HTML_ARTNOMBER" }] [{ $basketproduct->oxarticles__oxartnum->value }]
                                </p>
                            </td>
                            <td style="padding: 5px; border-bottom: 4px solid #ddd;">
                                <p style="font-family: Arial, Helvetica, sans-serif; font-size: 12px; margin: 0; padding: 10px 0;">
                                    <b>[{if $basketitem->getFUnitPrice() }][{ $basketitem->getFUnitPrice() }][{/if}]</b>
                                    [{if $basketitem->aDiscounts}]<br><br>
                                    <em style="font-size: 7pt;font-weight: normal;">[{ oxmultilang ident="EMAIL_ORDER_CUST_HTML_DISCOUNT" }]
                                        [{foreach from=$basketitem->aDiscounts item=oDiscount}]
                                        <br>[{ $oDiscount->sDiscount }]
                                        [{/foreach}]
                                    </em>
                                    [{/if}]
                                    [{ if $basketproduct->oxarticles__oxorderinfo->value }]
                                    [{ $basketproduct->oxarticles__oxorderinfo->value }]
                                    [{/if}]
                                </p>
                            </td>
                            <td style="padding: 5px; border-bottom: 4px solid #ddd;">
                                <p style="font-family: Arial, Helvetica, sans-serif; font-size: 12px; margin: 0; padding: 10px 0;">
                                    [{$basketitem->getAmount()}]
                                </p>
                            </td>
                            [{*<td style="padding: 5px; border-bottom: 4px solid #ddd;">
                                <p style="font-family: Arial, Helvetica, sans-serif; font-size: 12px; margin: 0; padding: 10px 0;">
                                    [{$basketitem->getVatPercent() }]%
                                </p>
                            </td>*}]
                            <td style="padding: 5px; border-bottom: 4px solid #ddd;">
                                <p style="font-family: Arial, Helvetica, sans-serif; font-size: 12px; margin: 0; padding: 10px 0;">
                                    <b>[{ $basketitem->getFTotalPrice() }]</b>
                                </p>
                            </td>
                        </tr>
                    [{/block}]
                [{/foreach}]
            </table>
            <br>

            [{block name="email_html_order_owner_giftwrapping"}]
                [{if $basket->oCard }]
                    <table border="0" cellspacing="0" cellpadding="2" width="100%">
                        <tr valign="top">
                            <td style="padding: 5px; border-bottom: 4px solid #ddd;">
                                <p style="font-family: Arial, Helvetica, sans-serif; font-size: 12px; margin: 0;">
                                    <b>[{ oxmultilang ident="EMAIL_ORDER_OWNER_HTML_ATENTIONGREETINGCARD" }]</b><br>
                                    <img src="[{$basket->oCard->getPictureUrl()}]" alt="[{$basket->oCard->oxwrapping__oxname->value}]" hspace="0" vspace="0" border="0" align="top">
                                </p>
                            </td>
                            <td style="padding: 5px; border-bottom: 4px solid #ddd;">
                                <p style="font-family: Arial, Helvetica, sans-serif; font-size: 12px; margin: 0;">
                                    [{ oxmultilang ident="EMAIL_ORDER_CUST_HTML_YOURMESSAGE" }]
                                    <br><br>
                                    [{$basket->getCardMessage()}]
                                </p>
                            </td>
                        </tr>
                    </table>
                    <br>
                [{/if}]
            [{/block}]

            <table border="0" cellspacing="0" cellpadding="2" width="100%">
                <tr>
                    <td width="50%" valign="top">
                        [{block name="email_html_order_owner_voucherdiscount"}]
                            [{if $oViewConf->getShowVouchers() }]
                                <table border="0" cellspacing="0" cellpadding="0">
                                    [{if $basket->getVoucherDiscValue() }]
                                    <tr valign="top">
                                        <td style="padding: 5px 20px 5px 5px; border-bottom: 2px solid #ccc;">
                                            <p style="font-family: Arial, Helvetica, sans-serif; font-size: 12px; margin: 0;  color: #555;">
                                                [{ oxmultilang ident="EMAIL_ORDER_CUST_HTML_USEDCOUPONS" }]
                                            </p>
                                        </td>
                                        <td style="padding: 5px 20px 5px 5px; border-bottom: 2px solid #ccc;">
                                            <p style="font-family: Arial, Helvetica, sans-serif; font-size: 12px; margin: 0;  color: #555;">
                                                [{ oxmultilang ident="EMAIL_ORDER_CUST_HTML_REBATE" }]
                                            </p>
                                        </td>
                                    </tr>
                                    [{/if}]
                                    [{ foreach from=$order->getVoucherList() item=voucher}]
                                    [{ assign var="voucherseries" value=$voucher->getSerie() }]
		                                <tr valign="top">
		                                    <td style="padding: 5px 20px 5px 5px;">
		                                        <p style="font-family: Arial, Helvetica, sans-serif; font-size: 12px; margin: 0;">
		                                            [{$voucher->oxvouchers__oxvouchernr->value}]
		                                        </p>
		                                    </td>
		                                    <td style="padding: 5px 20px 5px 5px;">
		                                        <p style="font-family: Arial, Helvetica, sans-serif; font-size: 12px; margin: 0;">
		                                            [{ $voucherseries->v6cGetFValue($currency) }]
		                                        </p>
		                                    </td>
		                                </tr>
                                    [{/foreach }]
                                </table>
                            [{/if}]
                        [{/block}]
                    </td>
                    <td width="50%" valign="top">
                        <table border="0" cellspacing="0" cellpadding="2" width="300">
                            [{*if !$basket->getDiscounts() }]
                                [{block name="email_html_order_owner_nodiscounttotalnet"}]
                                    <!-- netto price -->
                                    <tr valign="top">
                                        <td style="padding: 5px; border-bottom: 2px solid #ccc;">
                                            <p style="font-family: Arial, Helvetica, sans-serif; font-size: 12px; margin: 0;">
                                                [{ oxmultilang ident="EMAIL_ORDER_CUST_HTML_TOTALNET" }]
                                            </p>
                                        </td>
                                        <td style="padding: 5px; border-bottom: 2px solid #ccc;" align="right" width="60">
                                            <p style="font-family: Arial, Helvetica, sans-serif; font-size: 12px; margin: 0;">
                                                [{ $basket->getProductsNetPrice() }]
                                            </p>
                                        </td>
                                    </tr>
                                [{/block}]
                                [{block name="email_html_order_owner_nodiscountproductvats"}]
                                    <!-- VATs -->
                                    [{foreach from=$basket->getProductVats() item=VATitem key=key}]
                                        <tr valign="top">
                                            <td style="padding: 5px; border-bottom: 2px solid #ccc;">
                                                <p style="font-family: Arial, Helvetica, sans-serif; font-size: 12px; margin: 0;">
                                                    [{ oxmultilang ident="EMAIL_ORDER_CUST_HTML_PLUSTAX1" }] [{ $key }][{ oxmultilang ident="EMAIL_ORDER_CUST_HTML_PLUSTAX2" }]
                                                </p>
                                            </td>
                                            <td style="padding: 5px; border-bottom: 2px solid #ccc;" align="right">
                                                <p style="font-family: Arial, Helvetica, sans-serif; font-size: 12px; margin: 0;">
                                                    [{ $VATitem }]
                                                </p>
                                            </td>
                                        </tr>
                                    [{/foreach}]
                                [{/block}]
                            [{/if*}]

                            [{block name="email_html_order_owner_totalgross"}]
                                <!-- brutto price -->
                                <tr valign="top">
                                    <td style="padding: 5px; border-bottom: 2px solid #ccc;">
                                        <p style="font-family: Arial, Helvetica, sans-serif; font-size: 12px; margin: 0;">
                                            [{ oxmultilang ident="EMAIL_ORDER_CUST_HTML_TOTALGROSS" }]
                                        </p>
                                    </td>
                                    <td style="padding: 5px; border-bottom: 2px solid #ccc;" align="right">
                                        <p style="font-family: Arial, Helvetica, sans-serif; font-size: 12px; margin: 0;">
                                            [{ $basket->getFProductsPrice() }]
                                        </p>
                                    </td>
                                </tr>
                            [{/block}]

                            <!-- applied discounts -->
                            [{ if $basket->getDiscounts()}]

                                [{block name="email_html_order_owner_discounts"}]
                                    <!-- discounts -->
                                    [{foreach from=$basket->getDiscounts() item=oDiscount}]
                                        <tr valign="top">
                                             <td style="padding: 5px; border-bottom: 1px solid #ddd;">
                                                <p style="font-family: Arial, Helvetica, sans-serif; font-size: 12px; margin: 0;">
                                                    [{if $oDiscount->dDiscount < 0 }][{ oxmultilang ident="EMAIL_ORDER_CUST_HTML_CHARGE" }][{else}][{ oxmultilang ident="EMAIL_ORDER_CUST_HTML_DICOUNT" }][{/if}] <em>[{ $oDiscount->sDiscount }]</em>
                                                </p>
                                            </td>
                                            <td style="padding: 5px; border-bottom: 1px solid #ddd;" align="right">
                                                <p style="font-family: Arial, Helvetica, sans-serif; font-size: 12px; margin: 0;">
                                                    [{if $oDiscount->dDiscount < 0 }][{ $oDiscount->fDiscount|replace:"-":"" }][{else}]-[{ $oDiscount->fDiscount }][{/if}]
                                                </p>
                                            </td>
                                        </tr>
                                    [{/foreach}]
                                [{/block}]

                                [{*block name="email_html_order_owner_totalnet"}]
                                    <!-- netto price -->
                                    <tr valign="top">
                                        <td style="padding: 5px; border-bottom: 1px solid #ddd;">
                                            <p style="font-family: Arial, Helvetica, sans-serif; font-size: 12px; margin: 0;">
                                                [{ oxmultilang ident="EMAIL_ORDER_CUST_HTML_TOTALNET" }]
                                            </p>
                                        </td>
                                        <td style="padding: 5px; border-bottom: 1px solid #ddd;" align="right">
                                            <p style="font-family: Arial, Helvetica, sans-serif; font-size: 12px; margin: 0;">
                                                [{ $basket->getProductsNetPrice() }]
                                            </p>
                                        </td>
                                    </tr>
                                [{/block}]

                                [{block name="email_html_order_owner_productvats"}]
                                    <!-- VATs -->
                                    [{foreach from=$basket->getProductVats() item=VATitem key=key}]
                                        <tr valign="top">
                                            <td style="padding: 5px; border-bottom: 2px solid #ccc;">
                                                <p style="font-family: Arial, Helvetica, sans-serif; font-size: 12px; margin: 0;">
                                                    [{ oxmultilang ident="EMAIL_ORDER_CUST_HTML_PLUSTAX1" }] [{ $key }][{ oxmultilang ident="EMAIL_ORDER_CUST_HTML_PLUSTAX2" }]
                                                </p>
                                            </td>
                                            <td style="padding: 5px; border-bottom: 2px solid #ccc;" align="right">
                                                <p style="font-family: Arial, Helvetica, sans-serif; font-size: 12px; margin: 0;">
                                                    [{ $VATitem }]
                                                </p>
                                            </td>
                                        </tr>
                                    [{/foreach}]
                                [{/block*}]
                            [{/if}]

                            [{block name="email_html_order_owner_voucherdiscount"}]
                                <!-- voucher discounts -->
                                [{if $oViewConf->getShowVouchers() && $basket->getVoucherDiscValue() }]
                                    <tr valign="top">
                                        <td style="padding: 5px; border-bottom: 1px solid #ccc;">
                                            <p style="font-family: Arial, Helvetica, sans-serif; font-size: 12px; margin: 0;">
                                                [{ oxmultilang ident="EMAIL_ORDER_CUST_HTML_COUPON" }]
                                            </p>
                                        </td>
                                        <td style="padding: 5px; border-bottom: 1px solid #ccc;" align="right">
                                            <p style="font-family: Arial, Helvetica, sans-serif; font-size: 12px; margin: 0;">
                                                [{ if $basket->getVoucherDiscValue() > 0 }]-[{/if}][{ $basket->getFVoucherDiscountValue()|replace:"-":"" }]
                                            </p>
                                        </td>
                                    </tr>
                                [{/if}]
                            [{/block}]

                            [{ if $oViewConf->getShowGiftWrapping() && $basket->getFWrappingCosts() }]
                                [{block name="email_html_order_owner_wrappingcosts"}]
                                    <!-- Gift wrapping -->
                                    [{if $basket->getWrappCostVat()}]
                                        <tr valign="top">
                                            <td style="padding: 5px; border-bottom: 1px solid #ddd;">
                                                <p style="font-family: Arial, Helvetica, sans-serif; font-size: 12px; margin: 0;">
                                                    [{ oxmultilang ident="EMAIL_ORDER_CUST_HTML_WRAPPINGNET" }]
                                                </p>
                                            </td>
                                            <td style="padding: 5px; border-bottom: 1px solid #ddd;" align="right">
                                                <p style="font-family: Arial, Helvetica, sans-serif; font-size: 12px; margin: 0;">
                                                    [{ $basket->getWrappCostNet() }]
                                                </p>
                                            </td>
                                        </tr>
                                        <tr valign="top">
                                            <td style="padding: 5px; border-bottom: 1px solid #ddd;">
                                                <p style="font-family: Arial, Helvetica, sans-serif; font-size: 12px; margin: 0;">
                                                    [{ oxmultilang ident="EMAIL_ORDER_CUST_HTML_PLUSTAX21" }] [{ $basket->getWrappCostVatPercent() }][{ oxmultilang ident="EMAIL_ORDER_CUST_HTML_PLUSTAX22" }]
                                                </p>
                                            </td>
                                            <td style="padding: 5px; border-bottom: 1px solid #ddd;" align="right">
                                                <p style="font-family: Arial, Helvetica, sans-serif; font-size: 12px; margin: 0;">
                                                    [{ $basket->getWrappCostVat() }]
                                                </p>
                                            </td>
                                        </tr>
                                    [{/if}]
                                [{/block}]
                                [{block name="email_html_order_owner_giftwrapping"}]
                                    <tr valign="top">
                                        <td style="padding: 5px; border-bottom: 1px solid #ccc;">
                                            <p style="font-family: Arial, Helvetica, sans-serif; font-size: 12px; margin: 0;">
                                                [{ oxmultilang ident="EMAIL_ORDER_CUST_HTML_WRAPPINGANDGREETINGCARD1" }][{if $basket->getWrappCostVat()}] [{ oxmultilang ident="EMAIL_ORDER_CUST_HTML_WRAPPINGANDGREETINGCARD2" }][{/if}]
                                            </p>
                                        </td>
                                        <td style="padding: 5px; border-bottom: 1px solid #ccc;" align="right">
                                            <p style="font-family: Arial, Helvetica, sans-serif; font-size: 12px; margin: 0;">
                                                [{ $basket->getFWrappingCosts() }]
                                            </p>
                                        </td>
                                    </tr>
                                [{/block}]
                            [{/if}]

                            [{block name="email_html_order_owner_delcosts"}]
                                <!-- delivery costs -->
                                <!-- delivery VAT (if available) -->
                                [{if $basket->getDelCostVat() > 0}]
                                    <tr valign="top">
                                        <td style="padding: 5px; border-bottom: 1px solid #ddd;">
                                            <p style="font-family: Arial, Helvetica, sans-serif; font-size: 12px; margin: 0;">
                                                [{ oxmultilang ident="EMAIL_ORDER_CUST_HTML_SHIPPINGNET" }]
                                            </p>
                                        </td>
                                        <td style="padding: 5px; border-bottom: 1px solid #ccc;" align="right">
                                            <p style="font-family: Arial, Helvetica, sans-serif; font-size: 12px; margin: 0;">
                                                [{ $basket->getDelCostNet() }]
                                            </p>
                                        </td>
                                    </tr>
                                    <tr valign="top">
                                        <td style="padding: 5px; border-bottom: 1px solid #ddd;">
                                            <p style="font-family: Arial, Helvetica, sans-serif; font-size: 12px; margin: 0;">
                                                [{ oxmultilang ident="EMAIL_ORDER_OWNER_HTML_SHIPPINGVAT1" }] [{ $basket->getDelCostVatPercent() }][{ oxmultilang ident="EMAIL_ORDER_OWNER_HTML_SHIPPINGVAT2" }]:
                                            </p>
                                        </td>
                                        <td style="padding: 5px; border-bottom: 1px solid #ddd;" align="right">
                                            <p style="font-family: Arial, Helvetica, sans-serif; font-size: 12px; margin: 0;">
                                                [{ $basket->getDelCostVat() }]
                                            </p>
                                        </td>
                                    </tr>
                                [{/if}]
                            [{/block}]

                            <tr valign="top">
                                <td style="padding: 5px; border-bottom: 1px solid #ccc;">
                                    <p style="font-family: Arial, Helvetica, sans-serif; font-size: 12px; margin: 0;">
                                    [{ oxmultilang ident="EMAIL_ORDER_CUST_HTML_SHIPPINGGROSS1" }] [{if $basket->getDelCostVat() > 0}][{ oxmultilang ident="EMAIL_ORDER_CUST_HTML_SHIPPINGGROSS2" }][{/if}]
                                    </p>
                                </td>
                                <td style="padding: 5px; border-bottom: 1px solid #ccc;" align="right">
                                    <p style="font-family: Arial, Helvetica, sans-serif; font-size: 12px; margin: 0;">
                                        [{ $basket->getFDeliveryCosts() }]
                                    </p>
                                </td>
                            </tr>

                            [{block name="email_html_order_owner_paymentcosts"}]
                                <!-- payment sum -->
                                [{ if $basket->getPaymentCosts() }]
                                    <tr valign="top">
                                        <td style="padding: 5px; border-bottom: 1px solid #ccc;[{ if $basket->getDelCostVat() }]border-bottom: 1px solid #ddd;[{/if}]">
                                            <p style="font-family: Arial, Helvetica, sans-serif; font-size: 12px; margin: 0;">
                                                [{if $basket->getPaymentCosts() >= 0}][{ oxmultilang ident="EMAIL_ORDER_CUST_HTML_PAYMENTCHARGEDISCOUNT1" }][{else}][{ oxmultilang ident="EMAIL_ORDER_CUST_HTML_PAYMENTCHARGEDISCOUNT2" }][{/if}] [{ oxmultilang ident="EMAIL_ORDER_CUST_HTML_PAYMENTCHARGEDISCOUNT3" }]
                                            </p>
                                        </td>
                                        <td style="padding: 5px; border-bottom: 1px solid #ccc;[{ if $basket->getDelCostVat() }]border-bottom: 1px solid #ddd;[{/if}]" align="right">
                                            <p style="font-family: Arial, Helvetica, sans-serif; font-size: 12px; margin: 0;">
                                                [{ $basket->getPayCostNet() }]
                                            </p>
                                        </td>
                                    </tr>
                                    <!-- payment sum VAT (if available) -->
                                    [{ if $basket->getDelCostVat() }]
                                        <tr>
                                            <td style="padding: 5px; border-bottom: 1px solid #ccc;">
                                                <p style="font-family: Arial, Helvetica, sans-serif; font-size: 12px; margin: 0;">
                                                    [{ oxmultilang ident="EMAIL_ORDER_CUST_HTML_PAYMENTCHARGEVAT1" }] [{ $basket->getPayCostVatPercent()}][{ oxmultilang ident="EMAIL_ORDER_CUST_HTML_PAYMENTCHARGEVAT2" }]
                                                </p>
                                            </td>
                                            <td style="padding: 5px; border-bottom: 1px solid #ccc;" align="right">
                                                <p style="font-family: Arial, Helvetica, sans-serif; font-size: 12px; margin: 0;">
                                                    [{ $basket->getPayCostVat() }]
                                                </p>
                                            </td>
                                        </tr>
                                    [{/if}]
                                [{/if}]
                            [{/block}]

                            [{block name="email_html_order_owner_ts"}]
                                <!-- Trusted Shops -->
                                [{ if $basket->getTsProtectionCosts() }]
                                    <tr valign="top">
                                        <td style="padding: 5px; border-bottom: 1px solid #ccc;[{ if $basket->getTsProtectionVat() }]border-bottom: 1px solid #ddd;[{/if}]">
                                            <p style="font-family: Arial, Helvetica, sans-serif; font-size: 12px; margin: 0;">
                                            [{ oxmultilang ident="EMAIL_ORDER_CUST_HTML_TSPROTECTION" }]
                                            </p>
                                        </td>
                                        <td style="padding: 5px; border-bottom: 1px solid #ccc;[{ if $basket->getTsProtectionVat() }]border-bottom: 1px solid #ddd;[{/if}]" align="right">
                                            <p style="font-family: Arial, Helvetica, sans-serif; font-size: 12px; margin: 0;">
                                            [{ $basket->getTsProtectionNet() }]
                                            </p>
                                        </td>
                                    </tr>
                                    [{ if $basket->getTsProtectionVat() }]
                                        <tr valign="top">
                                            <td style="padding: 5px; border-bottom: 1px solid #ccc;">
                                                <p style="font-family: Arial, Helvetica, sans-serif; font-size: 12px; margin: 0;">
                                                [{ oxmultilang ident="EMAIL_ORDER_CUST_HTML_TSPROTECTIONCHARGETAX1" }] [{ $basket->getTsProtectionVatPercent()}][{ oxmultilang ident="EMAIL_ORDER_CUST_HTML_TSPROTECTIONCHARGETAX2" }]
                                                </p>
                                            </td>
                                            <td style="padding: 5px; border-bottom: 1px solid #ccc;" align="right">
                                                <p style="font-family: Arial, Helvetica, sans-serif; font-size: 12px; margin: 0;">
                                                [{ $basket->getTsProtectionVat() }]
                                                </p>
                                            </td>
                                        </tr>
                                    [{/if}]
                                [{/if}]
                            [{/block}]

		                    [{block name="v6c_email_html_order_owner_nataxes"}]
		                        [{ if $oViewConf->v6cIsTaxOff() }]
			                        <tr valign="top">
			                            <td style="padding: 5px; border-top: 2px solid #ccc; border-bottom: 1px solid #ccc;">
			                                <p style="font-family: Arial, Helvetica, sans-serif; font-size: 12px; margin: 0;">
			                                    <b>[{ oxmultilang ident="V6C_EMAIL_ORDER_CUST_HTML_PRETAXTOTAL" }]</b>
			                                </p>
			                            </td>
			                            <td style="padding: 5px; border-top: 2px solid #ccc; border-bottom: 1px solid #ccc;" align="right">
			                                <p style="font-family: Arial, Helvetica, sans-serif; font-size: 12px; margin: 0;">
			                                    [{ $basket->v6cGetFPriceNet() }]
			                                </p>
			                            </td>
			                        </tr>
			                    	[{if $oViewConf->v6cIsTaxLabelled() }]
			                    		[{foreach from=$basket->v6cGetBasketTaxes() item=sFTaxCost key=sTaxId }]
					                        <tr valign="top">
					                            <td style="padding: 5px; border-bottom: 1px solid #ccc;">
					                                <p style="font-family: Arial, Helvetica, sans-serif; font-size: 12px; margin: 0;">
					                                    [{ oxmultilang ident="V6C_EMAIL_ORDER_CUST_HTML_ORDERTAX1" }][{$sTaxId}][{ oxmultilang ident="V6C_EMAIL_ORDER_CUST_HTML_ORDERTAX2" }]
					                                </p>
					                            </td>
					                            <td style="padding: 5px; border-bottom: 1px solid #ccc;" align="right">
					                                <p style="font-family: Arial, Helvetica, sans-serif; font-size: 12px; margin: 0;">
					                                    [{$sFTaxCost}]
					                                </p>
					                            </td>
					                        </tr>
			                    		[{/foreach}]
			                    	[{else}]
				                        <tr valign="top">
				                            <td style="padding: 5px; border-bottom: 1px solid #ccc;">
				                                <p style="font-family: Arial, Helvetica, sans-serif; font-size: 12px; margin: 0;">
				                                    [{ oxmultilang ident="V6C_EMAIL_ORDER_CUST_HTML_ORDERTAX" }]
				                                </p>
				                            </td>
				                            <td style="padding: 5px; border-bottom: 1px solid #ccc;" align="right">
				                                <p style="font-family: Arial, Helvetica, sans-serif; font-size: 12px; margin: 0;">
				                                    [{ $basket->v6cGetFPriceTax() }]
				                                </p>
				                            </td>
				                        </tr>
			                    	[{/if}]
		                        [{/if}]
		                    [{/block}]

                            [{block name="email_html_order_owner_grandtotal"}]
                                <!-- grand total price -->
                                <tr valign="top">
                                    <td style="padding: 5px; border-top: 2px solid #ccc; border-bottom: 1px solid #ccc;">
                                        <p style="font-family: Arial, Helvetica, sans-serif; font-size: 12px; margin: 0;">
                                            <b>[{ oxmultilang ident="EMAIL_ORDER_CUST_HTML_GRANDTOTAL" }]</b>
                                        </p>
                                    </td>
                                    <td style="padding: 5px; border-top: 2px solid #ccc; border-bottom: 1px solid #ccc;" align="right">
                                        <p style="font-family: Arial, Helvetica, sans-serif; font-size: 12px; margin: 0;">
                                            <b>[{ $basket->getFPrice() }]</b>
                                        </p>
                                    </td>
                                </tr>
                            [{/block}]
                        </table>
                    </td>
                </tr>
            </table>

            [{block name="email_html_order_owner_userremark"}]
                [{ if $order->oxorder__oxremark->value }]
                    <h3 style="font-weight: bold; margin: 20px 0 7px; padding: 0; line-height: 35px; font-size: 12px;font-family: Arial, Helvetica, sans-serif; text-transform: uppercase; border-bottom: 4px solid #ddd;">
                        [{ oxmultilang ident="EMAIL_ORDER_OWNER_HTML_MESSAGE" }]
                    </h3>
                    <p style="font-family: Arial, Helvetica, sans-serif; font-size: 12px;">
                        [{ $order->oxorder__oxremark->value|oxescape }]
                    </p>
                [{/if}]
            [{/block}]

            [{block name="email_html_order_owner_paymentinfo"}]
                [{if $payment->oxuserpayments__oxpaymentsid->value != "oxempty"}]
                    <h3 style="font-weight: bold; margin: 20px 0 7px; padding: 0; line-height: 35px; font-size: 12px;font-family: Arial, Helvetica, sans-serif; text-transform: uppercase; border-bottom: 4px solid #ddd;">
                        [{ oxmultilang ident="EMAIL_ORDER_OWNER_HTML_PAYMENTINFO" }]
                    </h3>
                    <p style="font-family: Arial, Helvetica, sans-serif; font-size: 12px;">
                        <b>[{ oxmultilang ident="EMAIL_ORDER_CUST_HTML_PAYMENTMETHOD" }] [{ $payment->oxpayments__oxdesc->value }] [{ if $basket->getPaymentCosts() }]([{ $basket->getFPaymentCosts() }] [{ $currency->sign}])[{/if}]</b>
                        <br><br>
                        [{ oxmultilang ident="EMAIL_ORDER_OWNER_HTML_PAYMENTINFOOFF" }]
                    </p>
                    [{if $oViewConf->v6cIsMdlInst('merchantlink') && $aUsrPayParms}]
                    	<b>[{ oxmultilang ident="V6C_EMAIL_ORDER_OWNER_PAYMENTEXTRA" }]</b>
      					[{foreach from=$aUsrPayParms key=sKey item=sValue}]
        					[{$sKey}]: [{$sValue}]<br>
      					[{/foreach}]
      				[{/if}]
                [{/if}]
            [{/block}]

            [{block name="email_html_order_owner_username"}]
                <h3 style="font-weight: bold; margin: 20px 0 7px; padding: 0; line-height: 35px; font-size: 12px;font-family: Arial, Helvetica, sans-serif; text-transform: uppercase; border-bottom: 4px solid #ddd;">
                    [{ oxmultilang ident="EMAIL_ORDER_CUST_HTML_EMAILADDRESS" }]
                </h3>
                <p style="font-family: Arial, Helvetica, sans-serif; font-size: 12px;">
                    [{ $user->oxuser__oxusername->value }]
                </p>
            [{/block}]

            [{block name="email_html_order_owner_address"}]
                <!-- Address info -->
                <h3 style="font-weight: bold; margin: 20px 0 7px; padding: 0; line-height: 35px; font-size: 12px;font-family: Arial, Helvetica, sans-serif; text-transform: uppercase; border-bottom: 4px solid #ddd;">
                    [{ oxmultilang ident="EMAIL_ORDER_CUST_HTML_ADDRESS" }]
                </h3>

                <table colspan="0" rowspan="0" border="0">
                    <tr valign="top">
                        <td style="padding-right: 30xp">
                            <h4 style="font-weight: bold; margin: 0; padding: 0 0 15px; line-height: 20px; font-size: 11px;font-family: Arial, Helvetica, sans-serif; text-transform: uppercase;">
                                [{ oxmultilang ident="EMAIL_ORDER_CUST_HTML_BILLINGADDRESS" }]
                            </h4>
                            <p style="font-family: Arial, Helvetica, sans-serif; font-size: 12px; margin: 0;">
		                        [{include file="widget/address/billing_address.tpl" v6c_oOrder=$order v6c_bNoEmail=true}]
		                        [{if $order->oxorder__oxbillustid->value}][{ oxmultilang ident="EMAIL_ORDER_CUST_HTML_VATIDNOMBER" }] [{ $order->oxorder__oxbillustid->value }][{/if}]
                            </p>
                        </td>
                        [{ if $order->oxorder__oxdellname->value }]
                            <td>
                                <h4 style="font-weight: bold; margin: 0; padding: 0 0 15px; line-height: 20px; font-size: 11px;font-family: Arial, Helvetica, sans-serif; text-transform: uppercase;">
                                    [{ oxmultilang ident="EMAIL_ORDER_CUST_HTML_SHIPPINGADDRESS" }]
                                </h4>
                                <p style="font-family: Arial, Helvetica, sans-serif; font-size: 12px; margin: 0;">
                                    [{include file="widget/address/shipping_address.tpl" v6c_oOrder=$order v6c_bNoEmail=true}]
                                </p>
                            </td>
                        [{/if}]
                    </tr>
                </table>
            [{/block}]

            [{block name="email_html_order_owner_deliveryinfo"}]
                [{if $payment->oxuserpayments__oxpaymentsid->value != "oxempty"}]
                    <h3 style="font-weight: bold; margin: 20px 0 7px; padding: 0; line-height: 35px; font-size: 12px;font-family: Arial, Helvetica, sans-serif; text-transform: uppercase; border-bottom: 4px solid #ddd;">
                    [{ oxmultilang ident="EMAIL_ORDER_CUST_HTML_SHIPPINGCARRIER" }]
                    </h3>
                    <p style="font-family: Arial, Helvetica, sans-serif; font-size: 12px;">
                        [{ $oDelSet->oxdeliveryset__oxtitle->value }]
                    </p>
                [{/if}]
            [{/block}]

[{include file="email/html/footer.tpl"}]
