<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>
<script type="text/javascript">
	//AUIGrid 생성 후 반환 ID
	var detailGridID;
	
	// popup 크기
    var option = {
            winName : "popup",
            width : "950px",   // 창 가로 크기
            height : "700px",    // 창 세로 크기
            resizable : "yes", // 창 사이즈 변경. (yes/no)(default : yes)
            scrollbars : "yes" // 스크롤바. (yes/no)(default : yes)
    };
	
    $(document).ready(function(){
        
        // AUIGrid 그리드를 생성합니다.
        createAUIGrid();
        
//        AUIGrid.setSelectionMode(detailGridID, "singleRow");
        
        //Call Ajax
        orderInvestDetailGridAjax();
    
        if(gridParam.invReqStusParam.value == '1' || gridParam.invReqStusParam.value == '44'){
        	$("#pendingDiv").show();
        }
        
      //Btn Auth
        if(basicAuth == true){
            $("#_basicUpdBtn").css("display" , "");
        }else{
            $("#_basicUpdBtn").css("display" , "none");
        }
      
//        $('#btnDownFile').click(function() {
//            var fileSubPath = $('#subPath').val();
//            var fileName = $('#fileName').val();
//            var orignlFileNm = $('#orignlFileNm').val();
            
//            window.open("<c:url value='/file/fileDown.do?subPath=" + fileSubPath
//                + "&fileName=" + fileName + "&orignlFileNm=" + orignlFileNm + "'/>");
//        });
    });
    
    function createAUIGrid() {
        // AUIGrid 칼럼 설정
	    // 데이터 형태는 다음과 같은 형태임,
	    //[{"id":"#Cust0","date":"2014-09-03","name":"Han","country":"USA","product":"Apple","color":"Red","price":746400}, { .....} ];
	    var columnLayout = [ {
	            dataField : "name",
	            headerText : "<spring:message code='sal.title.status' />",
	            width : 100,
	            editable : false
	        }, {
	            dataField : "invReqItmRem",
	            headerText : "<spring:message code='sal.title.remark' />",
	            editable : false
	        }, {
	            dataField : "userName",
	            headerText : "<spring:message code='sal.title.respondBy' />",
	            width : 100,
	            editable : false
	        }, {
	            dataField : "invReqItmCrtDt",
	            headerText : "<spring:message code='sal.title.respondAt' />",
	            dataType : "date", 
                formatString : "dd/mm/yyyy",
	            width : 100,
	            editable : false
	        }];
    
	    // 그리드 속성 설정
        var gridPros = {
        
	        // 페이징 사용       
	        usePaging : false,
	        
	        // 한 화면에 출력되는 행 개수 20(기본값:20)
	        pageRowCount : 20,
	        
	        editable : true,
	        
	        fixedColumnCount : 1,
	        
	        showStateColumn : true, 
	        
	        displayTreeOpen : true,
	        
	        selectionMode : "multipleCells",
	        
	        headerHeight : 30,
	        
	        // 그룹핑 패널 사용
	        useGroupingPanel : false,
	        
	        // 읽기 전용 셀에 대해 키보드 선택이 건너 뛸지 여부
	        skipReadonlyColumns : true,
	        
	        // 칼럼 끝에서 오른쪽 이동 시 다음 행, 처음 칼럼으로 이동할지 여부
	        wrapSelectionMove : true,
	        
	        // 줄번호 칼럼 렌더러 출력
	        showRowNumColumn : true,
	        
	        groupingMessage : "Here groupping"
	    };
	    
	    //detailGridID = GridCommon.createAUIGrid("grid_wrap", columnLayout, gridPros);
	    detailGridID = AUIGrid.create("#pop_grid_wrap", columnLayout, gridPros);
	    //AUIGrid.resize(detailGridID, 800, 150);
	}
    
    // Ajax
    function orderInvestDetailGridAjax() {        
        Common.ajax("GET", "/sales/order/orderInvestDetailGridJsonList",$("#gridParam").serialize(), function(result) {
            AUIGrid.setGridData(detailGridID, result);
        });
    }
    
    function fn_stusChange(){
    	if(statusForm.statusPop.value == '44'){    // panding
    		$("#pendingDiv").show();
    		$("#approveDiv").hide();
    		$("#rejectDiv").hide();
    	}
    	if(statusForm.statusPop.value == '5'){     // approve
            $("#pendingDiv").show();
            $("#approveDiv").show();
            $("#rejectDiv").hide();
        }
    	if(statusForm.statusPop.value == '6'){     // reject
    		Common.ajax("GET", "/sales/order/orderInvestReject", $("#statusForm").serializeJSON(), function(result) {
//    			alert(result.existChkCnt);
//    			if(result.existChkCnt == '0' && $('input:checkbox[id="cancelBs"]').is(":checked") == true){
//                    alert("true");
//                }
                $("#existChk").html(result.existChkCnt);
                
    		});
            $("#pendingDiv").show();
            $("#approveDiv").hide();
            $("#rejectDiv").show();
        }
    	
    }
    
    function fn_inCharge(obj , value , tag , selvalue){
    	var robj= '#'+obj;
    	$(robj).attr("disabled",false);

    		getCmbChargeNm('/sales/order/inchargeJsonList.do', value , '' , selvalue,obj, 'S', '');
    }
    
    function getCmbChargeNm(url, groupCd ,codevalue ,  selCode, obj , type, callbackFn){
    	$.ajax({
            type : "GET",
            url : url,
            data : { roleId : groupCd},
            dataType : "json",
            contentType : "application/json;charset=UTF-8",
            success : function(data) {
               var rData = data;
               doDefNmCombo(rData, selCode, obj , type,  callbackFn)
            },
            error: function(jqXHR, textStatus, errorThrown){
                alert("Draw ComboBox['"+obj+"'] is failed. \n\n Please try again.");
            },
            complete: function(){
            }
        });
    }
    
    function doDefNmCombo(data, selCode, obj , type, callbackFn){
        var targetObj = document.getElementById(obj);
        var custom = "";

        for(var i=targetObj.length-1; i>=0; i--) {
            targetObj.remove( i );
        }
        obj= '#'+obj;
//        if (type&&type!="M") {
//            custom = (type == "S") ? eTrusttext.option.choose : ((type == "A") ? eTrusttext.option.all : "");
//            $("<option />", {value: "", text: custom}).appendTo(obj);
//        }else{
//            $(obj).attr("multiple","multiple");
//        }

        $.each(data, function(index,value) {
            //CODEID , CODE , CODENAME ,,description
            if(selCode==data[index].userId){
                $('<option />', {value : data[index].userId, text:data[index].userFullNm}).appendTo(obj).attr("selected", "true");
            }else{
                $('<option />', {value : data[index].userId, text:data[index].userFullNm}).appendTo(obj);
            }
        });


        if(callbackFn){
            var strCallback = callbackFn+"()";
            eval(strCallback);
        }
    }
    
    function fn_saveInvest(){
    	if(document.statusForm.statusRem.value == ""){
            Common.alert("<spring:message code='sal.alert.msg.pleaseEnterResponeRemark' /> !");
            return false;
        }
    	if(document.statusForm.statusPop.value == "5"){
    		if(document.statusForm.incharge.value == ""){
                Common.alert("<spring:message code='sal.alert.msg.pleaseSelectAnInchargeType' />");
                return false;
            }
        }
    	if(document.statusForm.statusPop.value == "6"){
    		if($('input:checkbox[id="cancelBs"]').is(":checked") == true){
                //alert("*Cannot Cancel BS Due to Current Month Are Not BS Month And BS Status Not Under Active.");
    			document.statusForm.cancelBsChk.value = "true";
            }else if($('input:checkbox[id="cancelBs"]').is(":checked") == false){
                //alert("false");
            	document.statusForm.cancelBsChk.value = "false";
            }
    		if(document.statusForm.cmbRejReason.value == ""){
                Common.alert("<spring:message code='sal.alert.msg.pleaseSelectARejectReason' />");
                return false;
            }
            
        }
    	
    	// $("#existChkCnt").val() check부터
    	
    	Common.ajax("GET", "/sales/order/saveInvest.do", $("#statusForm").serializeJSON(), function(result) {
            //$("#existChkCnt").html(result.existChkCnt);
            Common.alert(result.msg, fn_orderInvestigationListAjax);
            $("#_close").click();
        },  function(jqXHR, textStatus, errorThrown) {
            try {
                console.log("status : " + jqXHR.status);
                console.log("code : " + jqXHR.responseJSON.code);
                console.log("message : " + jqXHR.responseJSON.message);
                console.log("detailMessage : " + jqXHR.responseJSON.detailMessage);

                Common.alert("Failed to order invest reject.<br />"+"Error message : " + jqXHR.responseJSON.message + "</b>");
            }
            catch (e) {
                console.log(e);
              alert("Saving data prepration failed.");
            }
            alert("Fail : " + jqXHR.responseJSON.message);
        });
    }
    
    function fn_goLedger(){
    	Common.popupWin('gridParam', "/sales/order/orderLedgerViewPop.do", option);
    }
</script>
<div id="popup_wrap" class="popup_wrap"><!-- popup_wrap start -->

<header class="pop_header"><!-- pop_header start -->
<h1><spring:message code="sal.page.title.orderInvestigationRequestDetails" /></h1>
<ul class="right_opt">
    <li><p class="btn_blue2"><a href="#" id="_close"><spring:message code="sal.btn.close" /></a></p></li>
</ul>
</header><!-- pop_header end -->

<section class="pop_body"><!-- pop_body start -->

<section class="tap_wrap"><!-- tap_wrap start -->
<ul class="tap_type1">
    <li><a href="#" class="on"><spring:message code="sal.text.investigateRequestInfo" /></a></li>
    <li><a href="#"><spring:message code="sal.title.text.custInfo" /></a></li>
</ul>

<article class="tap_area"><!-- tap_area start -->

<aside class="title_line"><!-- title_line start -->
<h2><spring:message code="sal.title.text.particInfo" /></h2>
<ul class="right_btns">
    <li><p class="btn_blue"><a href="#" onclick="fn_goLedger()"><spring:message code="sal.btn.viewOrderLedger1" /></a></p></li>
</ul>
</aside><!-- title_line end -->

<form id="gridParam" name="gridParam" method="POST">
    <input type="hidden" id="gridInvReqId" name="gridInvReqId" value="${orderInvestInfo.invReqId }">
    <input type="hidden" id="invReqStusParam" name="invReqStusParam" value="${orderInvestInfo.invReqStusId }">
    <input type="hidden" id="ordId" name="ordId" value="${orderCustomerInfo.soId }">
</form>
<table class="type1"><!-- table start -->
<caption>table</caption>
<colgroup>
    <col style="width:150px" />
    <col style="width:*" />
    <col style="width:160px" />
    <col style="width:*" />
</colgroup>
<tbody>
<tr>
    <th scope="row"><spring:message code="sal.text.requestNo" /></th>
    <td><span>${orderInvestInfo.invReqNo }</span></td>
    <th scope="row"><spring:message code="sal.text.requestStatus" /></th>
    <td><span>${orderInvestInfo.name }</span></td>
</tr>
<tr>
    <th scope="row"><spring:message code="sal.text.product" /></th>
    <td><span>${orderCustomerInfo.stkDesc }</span></td>
    <th scope="row"><spring:message code="sal.text.rentalStatus" /></th>
    <td><span>${orderCustomerInfo.stusCodeName }</span></td>
</tr>
<tr>
    <th scope="row"><spring:message code="sal.text.ordNo" /></th>
    <td><span>${orderCustomerInfo.salesOrdNo }</span></td>
    <th scope="row"><spring:message code="sal.text.ordDate" /></th>
    <td><span>${orderCustomerInfo.salesDt }</span></td>
</tr>
<tr>
    <th scope="row"><spring:message code="sal.text.appType" /></th>
    <td><span>${orderCustomerInfo.codeName }</span></td>
    <th scope="row"><spring:message code="sal.title.text.rentalFees" /></th>
    <td><span>RM ${orderCustomerInfo.mthRentAmt }</span></td>
</tr>
<tr>
    <th scope="row"><spring:message code="sal.text.attachment" /></th>
    <td colspan="3">
    <c:if test="${orderCustomerInfo.invReqAttachFile eq '' }">
        <p class="btn_sky"><a href="#">No Attachment</a></p>
    </c:if>
    </td>
</tr>
<tr>
    <th scope="row"><spring:message code="sal.text.remark" /></th>
    <td colspan="3"><textarea cols="20" rows="5" disabled="disabled">${orderInvestInfo.invReqRem }</textarea></td>
</tr>
<tr>
    <th scope="row"><spring:message code="sal.text.requestDate" /></th>
    <td><span>${orderInvestInfo.invReqCrtDt }</span></td>
    <th scope="row"><spring:message code="sal.text.requestBy" /></th>
    <td><span>${orderInvestInfo.userName }</span></td>
</tr>
<tr>
    <th scope="row"><spring:message code="sal.text.lastUpdateAt" /></th>
    <td><span>${orderInvestInfo.invReqUpdDt }</span></td>
    <th scope="row"><spring:message code="sal.text.lastUpdateBy" /></th>
    <td><span>${orderInvestInfo.userName }</span></td>
</tr>
<tr>
    <th scope="row"><spring:message code="sal.text.response" /></th>
    <td colspan="3">

    <article class="grid_wrap" ><!-- grid_wrap start -->
        <div id="pop_grid_wrap" style="width:100%; height:150px; margin:0 auto;"></div>
    </article><!-- grid_wrap end -->

    </td>
</tr>
</tbody>
</table><!-- table end -->

</article><!-- tap_area end -->

<article class="tap_area"><!-- tap_area start -->

<aside class="title_line"><!-- title_line start -->
<h2><spring:message code="sal.page.title.custInformation" /></h2>
</aside><!-- title_line end -->

<table class="type1"><!-- table start -->
<caption>table</caption>
<colgroup>
    <col style="width:150px" />
    <col style="width:*" />
    <col style="width:160px" />
    <col style="width:*" />
</colgroup>
<tbody>
<tr>
    <th scope="row"><spring:message code="sal.text.customerId" /></th>
    <td><span>${orderCustomerInfo.custId }</span></td>
    <th scope="row"><spring:message code="sal.text.custType" /></th>
    <td><span>${orderCustomerInfo.codeDesc }</span></td>
</tr>
<tr>
    <th scope="row"><spring:message code="sal.text.custName" /></th>
    <td><span>${orderCustomerInfo.name }</span></td>
    <th scope="row"><spring:message code="sal.text.customerNRIC" /></th>
    <td><span>${orderCustomerInfo.nric }</span></td>
</tr>
</tbody>
</table><!-- table end -->

<aside class="title_line"><!-- title_line start -->
<h2><spring:message code="sal.text.mailingInformation" /> </h2>
</aside><!-- title_line end -->

<table class="type1"><!-- table start -->
<caption>table</caption>
<colgroup>
    <col style="width:150px" />
    <col style="width:*" />
    <col style="width:160px" />
    <col style="width:*" />
</colgroup>
<tbody>
<tr>
    <th scope="row"><spring:message code="sal.tap.title.contactPerson" /></th>
    <td colspan="3"><span>${orderCustomerInfo.custcntIdName }</span></td>
</tr>
<tr>
    <th scope="row"><spring:message code="sal.title.text.officeNo" /></th>
    <td><span>${orderCustomerInfo.custcntTelO }</span></td>
    <th scope="row"><spring:message code="sal.text.residenceNo" /></th>
    <td><span>${orderCustomerInfo.custcntTelR }</span></td>
</tr>
<tr>
    <th scope="row"><spring:message code="sal.text.faxNo" /></th>
    <td><span>${orderCustomerInfo.custcntTelF }</span></td>
    <th scope="row"><spring:message code="sal.title.text.mobileNo" /></th>
    <td><span>${orderCustomerInfo.custcntTelM1 }</span></td>
</tr>
<tr>
    <th scope="row"><spring:message code="sal.text.address" /></th>
    <td colspan="3"><span>${orderCustomerInfo.custaddAddr }</span></td>
</tr>
</tbody>
</table><!-- table end -->

<aside class="title_line"><!-- title_line start -->
<h2><spring:message code="sal.title.text.installInfomation" /> </h2>
</aside><!-- title_line end -->

<table class="type1"><!-- table start -->
<caption>table</caption>
<colgroup>
    <col style="width:150px" />
    <col style="width:*" />
    <col style="width:160px" />
    <col style="width:*" />
</colgroup>
<tbody>
<tr>
    <th scope="row"><spring:message code="sal.text.contactPerson" /></th>
    <td colspan="3"><span>${orderCustomerInfo.cntIdName }</span></td>
</tr>
<tr>
    <th scope="row"><spring:message code="sal.title.text.officeNo" /></th>
    <td><span>${orderCustomerInfo.cntTelO }</span></td>
    <th scope="row"><spring:message code="sal.text.residenceNo" /></th>
    <td><span>${orderCustomerInfo.cntTelR }</span></td>
</tr>
<tr>
    <th scope="row"><spring:message code="sal.text.faxNo" /></th>
    <td><span>${orderCustomerInfo.cntTelF }</span></td>
    <th scope="row"><spring:message code="sal.title.text.mobileNo" /></th>
    <td><span>${orderCustomerInfo.cntTelM1 }</span></td>
</tr>
<tr>
    <th scope="row"><spring:message code="sal.text.address" /></th>
    <td colspan="3"><span>${orderCustomerInfo.addAddr }</span></td>
</tr>
</tbody>
</table><!-- table end -->

</article><!-- tap_area end -->

</section><!-- tap_wrap end -->

<aside class="title_line"><!-- title_line start -->
<h2><spring:message code="sal.text.investigationRequestResultInfo" /></h2>
</aside><!-- title_line end -->

<form id="bsForm" name="bsForm" method="POST">
    <input type="hidden" id="existChk" name="existChk">
</form>
<div id="pendingDiv" style="display:none;"><!-- Status = Active일 경우 start -->
<form id="statusForm" name="statusForm" method="POST">
    <input type="hidden" id="salesOrdId" name="salesOrdId" value="${orderCustomerInfo.soId }">
    <input type="hidden" id="gridInvReqId" name="gridInvReqId" value="${orderInvestInfo.invReqId }">
    <input type="hidden" id="invReqStusParam" name="invReqStusParam" value="${orderInvestInfo.invReqStusId }">
    <input type="hidden" id="cancelBsChk" name="cancelBsChk" >
<table class="type1 mb1m"><!-- table start -->
<caption>table</caption>
<colgroup>
    <col style="width:150px" />
    <col style="width:*" />
</colgroup>
<tbody>
<tr>
    <th scope="row"><spring:message code="sal.text.status" /></th>
    <td>
    <select id="statusPop" name="statusPop" onchange="fn_stusChange()">
        <option value="44"><spring:message code="sal.text.pending" /></option>
        <option value="5"><spring:message code="sal.combo.text.approv" /></option>
        <option value="6"><spring:message code="sal.combo.text.rej" /></option>
    </select>
    <p><span class="blue_text">Pending - Pending for this case | Approve - Approve to investigate | Reject - Reject toinvestigate </span></p>
    </td>
</tr>
</tbody>
</table><!-- table end -->

<div id="approveDiv" style="display:none;"><!-- Status = Approve일 경우 start -->
<table class="type1 mt0 mb1m"><!-- table start -->
<caption>table</caption>
<colgroup>
    <col style="width:150px" />
    <col style="width:*" />
</colgroup>
<tbody>
<tr>
    <th scope="row" rowspan="2"><spring:message code="sal.text.incharge" /></th>
    <td>
    <select id="incharge" name="incharge" onchange="fn_inCharge('inchargeNm', this.value, '', '')">
        <option value="0">[Select One]</option>
        <option value="3"><spring:message code="sal.combo.text.internalCaller" /></option>
        <option value="4"><spring:message code="sal.title.text.thirdParty" /></option>
    </select>
    </td>
</tr>
<tr>
    <td>
    <select  id="inchargeNm" name="inchargeNm">
    </select>
    </td>
</tr>
</tbody>
</table><!-- table end -->
</div><!-- Status = Approve일 경우 end -->

<div id="rejectDiv" style="display:none;"><!-- Status = Reject일 경우 start -->
<table class="type1 mt0 mb1m"><!-- table start -->
<caption>table</caption>
<colgroup>
    <col style="width:150px" />
    <col style="width:*" />
</colgroup>
<tbody>
<tr>
    <th scope="row"><spring:message code="sal.title.text.rejReason" /></th>
    <td>
        <select id="cmbRejReason" name="cmbRejReason">
           <c:forEach var="list" items="${cmbRejReasonList }">
               <option value="${list.resnId }">${list.resnDesc }</option>
           </c:forEach>
        </select>
    <label><input type="checkbox" id="cancelBs" name="cancelBs"/><span><spring:message code="sal.text.cancelBSCurrent" /></span></label>
    </td>
</tr>
</tbody>
</table><!-- table end -->

</div><!-- Status = Reject 일 경우 end -->

<table class="type1 mt0 mb1m"><!-- table start -->
<caption>table</caption>
<colgroup>
    <col style="width:150px" />
    <col style="width:*" />
</colgroup>
<tbody>
<tr>
    <th scope="row"><spring:message code="sal.text.remark" /></th>
    <td>
    <textarea cols="20" id="statusRem" name="statusRem" rows="5" placeholder="" ></textarea>
    </td>
</tr>
</tbody>
</table><!-- table end -->
</form>
<div id="_basicUpdBtn">
<ul class="center_btns">
    <li><p class="btn_blue2 big"><a href="#" onclick="fn_saveInvest();"><spring:message code="sal.btn.save" /></a></p></li>
</ul>
</div>
</div>

</section><!-- pop_body end -->

</div><!-- popup_wrap end -->