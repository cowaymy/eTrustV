<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>

<script type="text/javaScript">
$(document).ready(function() {

	//Common.combo
	CommonCombo.make("_appTypePop", "/sales/rcms/getAppTypeList", {codeMasterId : '10'}, "66", optionModule);
	CommonCombo.make("_mainReason", "/sales/rcms/getReasonCodeList", {typeId : '1175' , stusCodeId : '1'},  '', {isShowChoose: false,isCheckAll : false, type: "M"});  //Reason Code
	CommonCombo.make("_rosCaller", "/sales/rcms/selectRosCaller", {stus:'1',agentType: this.value} ,'',  {id:'agentId', name:"agentName", isShowChoose: false,isCheckAll : false , type: "M"});

	$('#salesmanCd').change(function(event) {

        var memCd = $('#salesmanCd').val().trim();

        if(FormUtil.isNotEmpty(memCd)) {
            fn_loadOrderSalesman(0, memCd);
        }
    });

	$('#memBtn').click(function() {
        Common.popupDiv("/common/memberPop.do", $("#searchForm").serializeJSON(), null, true);
    });

	//Generate Report
	$("#_rptGen").click(function() {

		//Validation
		if($("#_keyStartDate").val() == null || $("#_keyStartDate").val() == '' || $("#_keyEndDate").val() == null || $("#_keyEndDate").val() == ''){
			Common.alert('<spring:message code="sal.alert.msg.plzSelKeyinDateFromTo" />');
			return;
		}

		//Search max 31Days Condition
        var startDate = $('#_keyStartDate').val();
        var endDate = $('#_keyEndDate').val();

        if( fn_getDateGap(startDate , endDate) > 31){
            Common.alert('<spring:message code="sal.alert.msg.dateTermThirtyOneDay" />');
            return;
        }

		if($("#_appTypePop").val() == null || $("#_appTypePop").val() == ''){
			Common.alert('<spring:message code="sal.alert.msg.plzSeloneAppType" />');
			return;
		}

		if($("#_actionType").val() == null || $("#_actionType").val() == ''){
            Common.alert('<spring:message code="sal.alert.msg.plzSeloneAction" />');
            return;
        }

		if(($("#_recallStr").val() != null && $("#_recallStr").val() != '') || ($("#_recallEnd").val() != null && $("#_recallEnd").val() != '')){
			if($("#_recallStr").val() == null || $("#_recallStr").val() == '' || $("#_recallEnd").val() == null || $("#_recallEnd").val() == ''){
				Common.alert('<spring:message code="sal.alert.msg.plzKeyInOrdNumFromTo" />');
				return;
			}
		}

		if(($("#_ptpStrdate").val() != null && $("#_ptpStrdate").val() != '') || ($("#_ptpEnddate").val() != null && $("#_ptpEnddate").val() != '')){
            if($("#_ptpStrdate").val() == null || $("#_ptpStrdate").val() == '' || $("#_ptpEnddate").val() == null || $("#_ptpEnddate").val() == ''){
                Common.alert('<spring:message code="sal.alert.msg.plzKeyInOrdDateFromTo" />');
                return;
            }
        }

		//Validation Pass
		//Gen Report
		var whereSql = '';
		var orderSql = '';
		var cnt = 0;

		if($("#_keyStartDate").val() != null && $("#_keyStartDate").val() != '' && $("#_keyEndDate").val() != null && $("#_keyEndDate").val() != ''){
			whereSql += " AND cr.CALL_CRT_DT BETWEEN TO_DATE('"+$("#_keyStartDate").val()+"', 'DD/MM/YYYY') AND TO_DATE('"+$("#_keyEndDate").val()+"', 'DD/MM/YYYY')";
        }

		if($("#hiddenSalesmanId").val() != null && $("#hiddenSalesmanId").val() != ''){
			whereSql += " AND cr.CALL_CRT_USER_ID = " + $("#hiddenSalesmanId").val();
		}

		//som.APP_TYPE_ID
		var runCnt = 0;
		var appStr = '';
		if($("#_appTypePop :selected").length > 0){
			$("#_appTypePop :selected").each(function(idx, el) {
				if(runCnt > 0){
					appStr += ',' +$(el).val();
				}else{
					appStr += $(el).val();
				}
				runCnt++;
			});
		}

		if(appStr != null && appStr != ''){
			whereSql += ' AND som.APP_TYPE_ID IN (' +appStr+')';
			runCnt = 0;
		}

		//cr.CALL_STUS_ID
		var actionStr = '';
		if($("#_actionType :selected").length > 0){
			$("#_actionType :selected").each(function(idx, el) {
				if(runCnt > 0){
					actionStr += ',' + $(el).val();
				}else{
					actionStr += $(el).val();
				}
				runCnt++;
			});
		}

		if(actionStr != null && actionStr != ''){
			whereSql += ' AND cr.CALL_STUS_ID IN ('+actionStr+')';
			runCnt = 0;
		}

        var rosCallerStr = '';
        if($("#_rosCaller :selected").length > 0){
            $("#_rosCaller :selected").each(function(idx, el) {
                if(runCnt > 0){
                	rosCallerStr += ',' + $(el).val();
                }else{
                	rosCallerStr += $(el).val();
                }
                runCnt++;
            });
        }

        if(rosCallerStr != null && rosCallerStr != ''){
            whereSql += ' AND RC.AGENT_ID IN ('+rosCallerStr+')';
            runCnt = 0;
        }

      //cr.CALL_STUS_ID
        var mainReasonStr= '';
        if($("#_mainReason :selected").length > 0){
            $("#_mainReason :selected").each(function(idx, el) {
                if(runCnt > 0){
                	mainReasonStr += ',' + $(el).val();
                }else{
                	mainReasonStr += $(el).val();
                }
                runCnt++;
            });
        }

        if(mainReasonStr != null && mainReasonStr != ''){
            whereSql += ' AND cr.ROS_CALL_MAIN_RESN_ID IN ('+mainReasonStr+')';
            runCnt = 0;
        }

		//Order Number
		if($("#_recallStr").val() != null && $("#_recallStr").val() != '' && $("#_recallEnd").val() != null && $("#_recallEnd").val() != ''){
			whereSql += " AND cr.CALL_DT BETWEEN TO_DATE('"+$("#_recallStr").val().trim()+"', 'DD/MM/YYYY') AND TO_DATE('"+$("#_recallEnd").val().trim()+"' , 'DD/MM/YYYY')";
		}

		//Order Date
		if($("#_ptpStrdate").val() != null && $("#_ptpStrdate").val() != '' && $("#_ptpEnddate").val() != null && $("#_ptpEnddate").val() != ''){
			whereSql += " AND ros.PTP_DT BETWEEN TO_DATE('"+$("#_ptpStrdate").val()+"', 'DD/MM/YYYY') AND TO_DATE('"+$("#_ptpEnddate").val()+"' , 'DD/MM/YYYY')";
		}

		//Cust ID
		if($("#_feedCustId").val() != null && $("#_feedCustId").val() != ''){
			whereSql += ' AND c.CUST_ID = ' + $("#_feedCustId").val().trim();
		}

		//Cust Name (Like Search)
		if($("#_feedCustName").val() != null && $("#_feedCustName").val() != ''){
			whereSql += " AND UPPER(c.NAME) LIKE '%'||UPPER('"+$("#_feedCustName").val()+"')||'%''";
		}

		//NRIC
		if($("#_feedNric").val() != null && $("#_feedNric").val() != ''){
			whereSql += " AND UPPER(c.NRIC) LIKE '%'||UPPER('"+$("#_feedNric").val()+"')||'%''";
		}

		//Order By
		if($("#_sortBy").val() != null && $("#_sortBy").val() != ''){

			if($("#_sortBy").val() == '1'){
				orderSql = " ORDER BY cr.CALL_CRT_DT , som.SALES_ORD_NO";
			}else if($("#_sortBy").val() == '2'){
				orderSql = " ORDER BY u.USER_NAME, cr.CALL_CRT_DT, som.SALES_ORD_NO";
			}else if($("#_sortBy").val() == '3'){
				orderSql = " ORDER BY som.SALES_ORD_NO, cr.CALL_CRT_DT";
            }else if($("#_sortBy").val() == '4'){
            	orderSql = " ORDER BY t.CODE, som.SALES_ORD_NO, cr.CALL_CRT_DT";
            }else if($("#_sortBy").val() == '5'){
            	orderSql = " ORDER BY s2.NAME, som.SALES_ORD_NO, cr.CALL_CRT_DT";
            }else{
            	orderSql = " ";
            }
		}

		//title
	    var date = new Date().getDate();
	    if(date.toString().length == 1){
	        date = "0" + date;
	    }
	    var title = "ROSFeedbackKeyInList_"+date+(new Date().getMonth()+1)+new Date().getFullYear();
	    $("#_feedRptForm #reportDownFileName").val(title); //Download File Name

	    /* Procedure Params */
	    $("#V_SELECTSQL").val(" ");
	    $("#_feedRptForm #V_WHERESQL").val(whereSql);
	    $("#V_ORDERBYSQL").val(orderSql);
	    $("#V_SELECTSQL").val(" ");

	    console.log($("#_feedRptForm").serializeJSON());

	  //Gen Report
	    var option = {
	            isProcedure : true // procedure 로 구성된 리포트 인경우 필수.  => /payment/PaymentListing_Excel.rpt 는 프로시져로 구성된 파일임.
	    };
	    Common.report("_feedRptForm", option);

	});//Gen End
});

function fn_getDateGap(sdate, edate){

    var startArr, endArr;

    startArr = sdate.split('/');
    endArr = edate.split('/');

    var keyStartDate = new Date(startArr[2] , startArr[1] , startArr[0]);
    var keyEndDate = new Date(endArr[2] , endArr[1] , endArr[0]);

    var gap = (keyEndDate.getTime() - keyStartDate.getTime())/1000/60/60/24;

//    console.log("gap : " + gap);

    return gap;
}


function fn_loadOrderSalesman(memId, memCode) {

    Common.ajax("GET", "/sales/order/selectMemberByMemberIDCode.do", {memId : memId, memCode : memCode}, function(memInfo) {

        if(memInfo == null) {
            Common.alert('<spring:message code="sal.alert.msg.memNotFoundInput" />'+memCode+'</b>');
            $("#salesmanPopCd").val('');
            $("#hiddenSalesmanPopId").val('');
        }
        else{
       	    $('#hiddenSalesmanId').val(memInfo.memId);
            $('#salesmanCd').val(memInfo.memCode);
            $('#salesmanCd').removeClass("readonly");
        }
    });
}

 //Multy Select
$('.multy_select').change(function() {
  //console.log($(this).val());
      })
      .multipleSelect({
      width: '100%'
});
</script>

<div id="popup_wrap" class="popup_wrap"><!-- popup_wrap start -->

<form id="_feedRptForm">
    <!-- Essential Params -->
    <input type="hidden" id="reportFileName" name="reportFileName" value="/sales/ROSFeedbackKeyList.rpt" />
    <input type="hidden" id="viewType" name="viewType" value="EXCEL"/>
    <input type="hidden" id="reportDownFileName" name="reportDownFileName"  />

    <!-- Procedure Params -->
    <input type="hidden" id="V_SELECTSQL" name="V_SELECTSQL">
    <input type="hidden" id="V_WHERESQL" name="V_WHERESQL">
    <input type="hidden" id="V_ORDERBYSQL" name="V_ORDERBYSQL">
    <input type="hidden" id="V_FULLSQL" name="V_FULLSQL">

</form>

<header class="pop_header"><!-- pop_header start -->
<h1><spring:message code="sal.title.rosFeedbackList" /></h1>
<ul class="right_opt">
    <li><p class="btn_blue2"><a href="#"><spring:message code="sal.btn.close" /></a></p></li>
</ul>
</header><!-- pop_header end -->
<section class="pop_body"><!-- pop_body start -->
<form  id="searchForm">
<table class="type1"><!-- table start -->
<caption>table</caption>
<colgroup>
    <col style="width:100px" />
    <col style="width:*" />
    <col style="width:100px" />
    <col style="width:*" />
</colgroup>
<tbody>
<tr>
    <th scope="row"><spring:message code="sal.text.keyInDate" /></th>
    <td>
    <div class="date_set w100p"><!-- date_set start -->
    <p><input type="text" title="Create start Date" placeholder="DD/MM/YYYY" class="j_date"  id="_keyStartDate" /></p>
    <span><spring:message code="sal.title.to" /></span>
    <p><input type="text" title="Create end Date" placeholder="DD/MM/YYYY" class="j_date" id="_keyEndDate" /></p>
    </div><!-- date_set end -->
    </td>
    <th scope="row"><spring:message code="sal.title.text.keyUser" /></th>
    <td>
        <div class="search_100p"><!-- search_100p start -->
        <input id="salesmanCd" name="salesmanCd" type="text" title="" placeholder="" class="w100p" />
        <input id="hiddenSalesmanId" name="salesmanId" type="hidden"  />
        <a id="memBtn" href="#" class="search_btn"><img src="${pageContext.request.contextPath}/resources/images/common/normal_search.gif" alt="search" /></a>
        </div>
    </td>
</tr>
<tr>
    <th scope="row"><spring:message code="sal.text.appType" /></th>
    <td>
        <select id="_appTypePop" name="appType" class="multy_select w100p" multiple="multiple"></select>
    </td>
    <th scope="row"><spring:message code="sal.title.text.action" /></th>
    <td>
        <select id="_actionType" name="actionType" class="multy_select w100p" multiple="multiple">
            <option value="56"><spring:message code="sal.combo.text.callIn" /></option>
            <option value="57"><spring:message code="sal.combo.text.callOut" /></option>
            <option value="58"><spring:message code="sal.combo.text.internalFeedback" /></option>
        </select>
    </td>
</tr>
<tr>
    <th scope="row"><spring:message code="sal.text.customerId" /></th>
    <td><input type="text" class="w100p" id="_feedCustId"></td>
    <th scope="row"><spring:message code="sal.text.custName" /></th>
    <td><input type="text" class="w100p" id="_feedCustName"></td>
</tr>
<tr>
    <th scope="row"><spring:message code="sal.title.text.reCallDate" /></th>
    <td>
    <div class="date_set w100p"><!-- date_set start -->
    <p><input type="text" title="Create start Date" placeholder="DD/MM/YYYY" class="j_date" id="_recallStr" /></p>
    <span><spring:message code="sal.title.to" /></span>
    <p><input type="text" title="Create end Date" placeholder="DD/MM/YYYY" class="j_date" id="_recallEnd"/></p>
    </div><!-- date_set end -->
    </td>
    <th scope="row"><spring:message code="sal.title.text.ptpDate" /></th>
    <td>
    <div class="date_set w100p"><!-- date_set start -->
    <p><input type="text" title="Create start Date" placeholder="DD/MM/YYYY" class="j_date" id="_ptpStrdate" /></p>
    <span><spring:message code="sal.title.to" /></span>
    <p><input type="text" title="Create end Date" placeholder="DD/MM/YYYY" class="j_date" id="_ptpEnddate"/></p>
    </div><!-- date_set end -->
    </td>
</tr>
<tr>
     <th scope="row"><spring:message code="sal.title.text.rosCaller" /></th>
       <td>
          <select id="_rosCaller" name="_rosCaller" class="multy_select w100p" multiple="multiple"></select>
       </td>
     <th scope="row"><spring:message code="sal.title.text.mainReason" /></th>
       <td>
          <select class="w100p" id="_mainReason" name="_mainReason"></select>
       </td>
</tr>
<tr>
    <th scope="row"><spring:message code="sal.title.text.sortBy" /></th>
    <td colspan="3">
        <select id="_sortBy" name="sortBy" class="w50p">
            <option value="1"><spring:message code="sal.combo.text.byKeyInDate" /></option>
            <option value="2"><spring:message code="sal.combo.text.byKeyInUser" /></option>
            <option value="3"><spring:message code="sal.combo.text.byOrdNumber" /></option>
            <option value="4"><spring:message code="sal.combo.text.byApplicationType" /></option>
            <option value="5"><spring:message code="sal.combo.text.byAction" /></option>
        </select>
    </td>
</tr>
</tbody>
</table><!-- table end -->
</form>

<ul class="center_btns">
    <li><p class="btn_blue2"><a id="_rptGen" ><spring:message code="sal.btn.generate" /></a></p></li>
    <li><p class="btn_blue2"><a onclick="javascript:$('#searchForm').clearForm();"><spring:message code="sal.btn.clear" /></a></p></li>
</ul>
</section>
</div>