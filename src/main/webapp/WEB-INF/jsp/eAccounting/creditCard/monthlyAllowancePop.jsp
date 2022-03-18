<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>
<style type="text/css">
/* 커스텀 칼럼 스타일 정의 */
</style>
<script  type="text/javascript">
    var clmYyyy, clmMm;
    var result = $.parseJSON('${result}');

    $(document).ready(function(){
        console.log("monthlyAllowancePop.jsp")

        console.log(result[0]);
        console.log("${item}");

        $("#hiddenCrcId").val("${item.crcId}")

        var clmMonth = "${item.clmMonth}";
        clmYyyy = clmMonth.substring(0, 4);
        clmMm = clmMonth.substring(4);

        var crcNo = result[0].crditCardNo;

        $("#monthYear").val(clmMm + "/" + clmYyyy);
        $("#costCenter").val(result[0].costCenter);
        $("#costCenterDesc").val(result[0].costCenterName);
        $("#crcNo").val(crcNo.substring(0, 6) + "******" + crcNo.substring(12));
        $("#crcHolderNm").val(result[0].crditCardholderNm);

        $("#allowanceAmt").text(comma(result[0].creditLimit));
        $("#adjustAmt").text(comma(result[0].adjAmt));
        $("#pendAppvAmt").text(comma(result[0].pendingAmt));
        $("#consumAppvAmt").text(comma(result[0].utilizedAmt));
        $("#availableAmt").text(comma(result[0].availableAmt));
    });

    function comma(str) {
        str = String(str);
        return str.replace(/(\d)(?=(?:\d{3})+(?!\d))/g, '$1,');
    }

    function fn_adjustmentPop() {
        console.log("fn_adjustmentPop");
        $("#monthlyAllowancePop").remove();

        var data = {
                mode : "N",
                clmMm : clmMm,
                clmYyyy : clmYyyy,
                crcId : $("#hiddenCrcId").val()
        };

        Common.popupDiv("/eAccounting/creditCard/crcAdjustmentPop.do", data, null, true, "crcAdjustmentPop");
    }
</script>

<div id="popup_wrap" class="popup_wrap">
    <header class="pop_header">
    <h1><spring:message code="budget.AvailableBudgetDisplay" /></h1>
        <ul class="right_opt">
            <li><p class="btn_blue2"><a href="#"><spring:message code="expense.CLOSE" /></a></p></li>
        </ul>
    </header>

    <section class="pop_body" style="min-height:200px">
        <section class="search_table">
            <form action="#" method="post" id="pForm" name="pForm">

                <input type="hidden" id="hiddenCrcId" name="hiddenCrcId" />

	            <table class="type1">
	                <caption>table</caption>
	                <colgroup>
	                    <col style="width:150px" />
	                    <col style="width:*" />
	                    <col style="width:150px" />
	                    <col style="width:*" />
	                </colgroup>
	                <tbody>
	                    <tr>
	                        <th scope="row"><spring:message code="budget.Month" />/<spring:message code="budget.Year" /></th>
	                        <td colspan="3">
	                            <input type="text" title="" placeholder="" class="readonly" readonly="readonly" style="width:100px" id="monthYear" name="monthYear" />
	                        </td>
	                    </tr>
	                    <tr>
	                        <th scope="row"><spring:message code="budget.CostCenter" /></th>
	                        <td>
	                            <input type="text" id="costCenter" name ="costCenter" title="" placeholder="" class="readonly w100p" readonly="readonly"  value="${item.costCentr }"/>
	                        </td>
	                        <th scope="row"><spring:message code="budget.CostCenter" /> <spring:message code="budget.Description" /></th>
	                        <td>
	                            <input type="text"  id="costCenterDesc" name ="costCenterDesc" title="" placeholder="" class="readonly w100p" readonly="readonly"  value="${item.costCenterText }"/>
	                        </td>
	                    </tr>
	                    <tr>
	                        <th scope="row">Credit Card No</th>
	                        <td>
	                            <input type="text"  id="crcNo" name ="crcNo" title="" placeholder="" class="readonly w100p" readonly="readonly" />
	                        </td>
	                        <th scope="row">Credit Cardholder Name</th>
	                        <td>
	                            <input type="text"  id="crcHolderNm" name ="crcHolderNm" title="" placeholder="" class="readonly w100p" readonly="readonly" />
	                        </td>
	                    </tr>
	                </tbody>
	            </table>

	            <table class="type2 mt30">
	                <caption>table</caption>
	                <colgroup>
	                    <col style="width:auto" />
	                </colgroup>
	                <thead>
	                <tr>
	                    <th scope="col" class="bg_color_gray">Allowance Limit</th>
	                    <th scope="col" class="bg_color_gray">Adjustment Amount</th>
	                    <th scope="col" class="bg_color_gray">Draft Amount</th>
	                    <th scope="col" class="bg_color_gray">Utilised Amount</th>
	                    <th scope="col" class="black_text bold_text"><spring:message code="budget.Available" /> <spring:message code="budget.Amount" /></th>
	                </tr>
	                </thead>

	                <tbody>
	                    <tr>
	                        <td><span id='allowanceAmt'></span></td>
	                        <td><span id='adjustAmt'></span></td>
	                        <td><span id="pendAppvAmt"></span></td>
	                        <td><span id="consumAppvAmt"></span></td>
	                        <td><span id="availableAmt"></span></td>
	                    </tr>
	                </tbody>
	            </table>

	            <ul class="center_btns">
	                <li><p class="btn_blue"><a href="#" onclick="javascript:fn_adjustmentPop()">Adjustment</a></p></li>
	            </ul>

            </form>
        </section>
    </section>
</div>