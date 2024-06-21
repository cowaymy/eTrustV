<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c"      uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<script type="text/javascript" src="${pageContext.request.contextPath}/resources/js/homecare-js-1.0.js"></script>
<script type="text/javaScript">

// 화면 초기화 함수 (jQuery 의 $(document).ready(function() {}); 과 같은 역할을 합니다.
$(document).ready(function(){


});


function fn_genDocument(){

	if(FormUtil.checkReqValue($('#payDateFr')) || FormUtil.checkReqValue($('#payDateTo'))){
		Common.alert("<spring:message code='pay.alert.payDateFromTo'/>");
		return;
	}

	//report 안쓴다.
	//var option = {
	//        isProcedure : true, // procedure 로 구성된 리포트 인경우 필수.  => /payment/PaymentListing_Excel.rpt 는 프로시져로 구성된 파일임.
	//};

	//Common.report("searchForm", option);

	var payDateFr = $("#payDateFr").val();
	var payDateTo = $("#payDateTo").val();

	Common.ajax("GET", "/payment/countDailyCollectionData.do", $("#searchForm").serialize(), function(result) {
		var cnt = result;

		console.log("dailyCollection cnt : " + cnt);

		if(cnt > 0){
			Common.showLoader();
			$.fileDownload("/payment/selectDailyCollectionData.do?payDateFr=" + payDateFr + "&payDateTo="+payDateTo)
				.done(function () {
					Common.alert("<spring:message code='pay.alert.downSuccess'/>");
					Common.removeLoader();
				})
				.fail(function () {
					Common.alert("<spring:message code='pay.alert.downFail'/>");
					Common.removeLoader();
				});
		}else{
			Common.alert("<spring:message code='sys.info.grid.noDataMessage'/>");
		}
	});
}
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
function fn_searchCollection() {

/*     if(FormUtil.checkReqValue($('#payDateFr')) || FormUtil.checkReqValue($('#payDateTo'))){
        Common.alert("<spring:message code='pay.alert.payDateFromTo'/>");
        return;
    } */

    var payDateFr = $("#payDateFr").val();
    var payDateTo = $("#payDateTo").val();
    var dt_range = $('#dt_range').val();

    var valid = true;
    var msg = "";

    console.log ();
    console.log ("== payDateFr == " + payDateFr);
    console.log ("== payDateTo == " + payDateTo);

    if (payDateFr == '' && payDateTo == ''){
        msg = "Request Date is required.";
        valid = false;
    } else if (payDateFr != '' && payDateTo == '') {
        msg = "Request End Date is required.";
        valid = false;
    } else if (payDateFr == '' && payDateTo != '') {
        msg = "Request Start Date is required.";
        valid = false;
    } else if (payDateFr != '' && payDateTo != ''){
        if (!fn_checkDateRange(payDateFr,payDateTo,"Request"))
        valid = false;
    }

    if (valid){
    	Common.showLoader();
    $.fileDownload("/payment/selectDailyCollectionData.do?payDateFr=" + payDateFr + "&payDateTo="+payDateTo)
    .done(function () {
        Common.alert("<spring:message code='pay.alert.downSuccess'/>");
        Common.removeLoader();
    })
    } else {
        Common.alert(msg);
    }

}


function fn_clear(){
    $("#searchForm")[0].reset();
}


function fn_checkDateRange(payDateFr, payDateTo, field){

    var arrStDt = payDateFr.split('/');
    var arrEnDt = payDateTo.split('/');
    //var dat1 = new Date(arrStDt[2], arrStDt[1], arrStDt[0]);
    var dat1 = new Date(arrStDt[2], arrStDt[1] - 1, arrStDt[0]);
    //var dat2 = new Date(arrEnDt[2], arrEnDt[1], arrEnDt[0]);
    var dat2 = new Date(arrEnDt[2], arrEnDt[1] - 1, arrEnDt[0]);


    console.log ("== arrStDt == " + arrStDt);
    console.log ("== arrEnDt == " + arrEnDt);
    console.log ("== dat1 == " + dat1);
    console.log ("== dat2 == " + dat2);

    var diff = dat2 - dat1;

    console.log ("== diff == " + diff);
    console.log ("== range check == " + js.date.dateDiff(dat1, dat2));
    if(diff < 0){
        Common.alert(field + " End Date MUST be greater than " + field + " Start Date.");
        return false;
    }

    if(js.date.dateDiff(dat1, dat2) > 7){
        Common.alert("Please keep the " + field + " range within 7 days.");
        return false;
    }

    return true;
}

</script>

<!-- content start -->
<section id="content">
    <ul class="path">
        <li><img src="${pageContext.request.contextPath}/resources/images/common/path_home.gif" alt="Home" /></li>
    </ul>

    <!-- title_line start -->
    <aside class="title_line">
        <p class="fav"><a href="#" class="click_add_on"><spring:message code='pay.text.myMenu'/></a></p>
        <h2>Daily Collection Raw</h2>
        <ul class="right_btns">
            <c:if test="${PAGE_AUTH.funcPrint == 'Y'}">
            <%-- <li><p class="btn_blue"><a href="javascript:fn_genDocument();"><spring:message code='pay.btn.generate'/></a></p></li> --%>
            <li><p class="btn_blue"><a href="javascript:fn_searchCollection();"><spring:message code='sys.btn.search'/></a></p></li>
            </c:if>
            <li><p class="btn_blue"><a href="javascript:fn_clear();"><span class="clear"></span><spring:message code='sys.btn.clear'/></a></p></li>
        </ul>
    </aside>
    <!-- title_line end -->

    <!-- search_table start -->
    <section class="search_table">
        <form name="searchForm" id="searchForm"  method="post">
            <input type="hidden" id="reportFileName" name="reportFileName" value="/payment/DailyCollectionReport_Excel.rpt" />
            <input type="hidden" id="viewType" name="viewType" value="EXCEL" />
            <table class="type1"><!-- table start -->
                <caption>table</caption>
				<colgroup>
				    <col style="width:150px" />
				    <col style="width:300px" />
				    <col style="width:*" />
				</colgroup>
				<tbody>
				    <tr>
				        <th scope="row">Trx Date</th>
					    <td>
					           <div class="date_set  w100p"><!-- date_set start -->
					           <p><input id="payDateFr" name="payDateFr" type="text" title="Pay start Date" placeholder="DD/MM/YYYY" class="j_date" readonly />
					           </p>
					           <span>~</span>
					           <p><input id="payDateTo" name="payDateTo"  type="text" title="Pay end Date" placeholder="DD/MM/YYYY" class="j_date" readonly  /></p>
					           </div><!-- date_set end -->
					    </td>
					    <td>
					    </td>
                    </tr>
                </tbody>
            </table>
            <!-- table end -->
        </form>
    </section>
    <!-- search_table end -->
</section>
