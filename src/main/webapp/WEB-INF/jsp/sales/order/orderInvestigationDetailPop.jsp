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
        
        AUIGrid.setSelectionMode(detailGridID, "singleRow");
        
        //Call Ajax
        orderInvestDetailGridAjax();
    
        if(gridParam.invReqStusParam.value == '1' || gridParam.invReqStusParam.value == '44'){
        	$("#pendingDiv").show();
        }
    });
    
    function createAUIGrid() {
        // AUIGrid 칼럼 설정
	    // 데이터 형태는 다음과 같은 형태임,
	    //[{"id":"#Cust0","date":"2014-09-03","name":"Han","country":"USA","product":"Apple","color":"Red","price":746400}, { .....} ];
	    var columnLayout = [ {
	            dataField : "name",
	            headerText : "Status",
	            width : 100,
	            editable : false
	        }, {
	            dataField : "invReqItmRem",
	            headerText : "Remark",
	            editable : false
	        }, {
	            dataField : "userName",
	            headerText : "Respond By",
	            width : 100,
	            editable : false
	        }, {
	            dataField : "invReqItmCrtDt",
	            headerText : "Respond At",
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
    	if(value == 3){
    		getCmbChargeNm('/sales/order/inchargeJsonList.do', value , '' , selvalue,obj, 'S', '');
    	}else{
    		
    	}
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
            Common.alert("Please enter respone remark !");
            return false;
        }
    	if(document.statusForm.statusPop.value == "5"){
    		if(document.statusForm.incharge.value == ""){
                Common.alert("Please select an incharge type.");
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
                Common.alert("Please select a Reject Reason.");
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
<h1>Order Investigation Request Details - Officer</h1>
<ul class="right_opt">
    <li><p class="btn_blue2"><a href="#" id="_close">CLOSE</a></p></li>
</ul>
</header><!-- pop_header end -->

<section class="pop_body"><!-- pop_body start -->

<section class="tap_wrap"><!-- tap_wrap start -->
<ul class="tap_type1">
    <li><a href="#" class="on">Investigate Request Info</a></li>
    <li><a href="#">Customer Info</a></li>
</ul>

<article class="tap_area"><!-- tap_area start -->

<aside class="title_line"><!-- title_line start -->
<h2>Particular Information</h2>
<ul class="right_btns">
    <li><p class="btn_blue"><a href="#" onclick="fn_goLedger()">View Rent Ledger</a></p></li>
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
    <th scope="row">Request No.</th>
    <td><span>${orderInvestInfo.invReqNo }</span></td>
    <th scope="row">Request Status</th>
    <td><span>${orderInvestInfo.name }</span></td>
</tr>
<tr>
    <th scope="row">Product</th>
    <td><span>${orderCustomerInfo.stkDesc }</span></td>
    <th scope="row">Rental Status</th>
    <td><span>${orderCustomerInfo.stusCodeName }</span></td>
</tr>
<tr>
    <th scope="row">Order No</th>
    <td><span>${orderCustomerInfo.salesOrdNo }</span></td>
    <th scope="row">Order Date</th>
    <td><span>${orderCustomerInfo.salesDt }</span></td>
</tr>
<tr>
    <th scope="row">Application Type</th>
    <td><span>${orderCustomerInfo.codeName }</span></td>
    <th scope="row">Rental Fees</th>
    <td><span>RM ${orderCustomerInfo.mthRentAmt }</span></td>
</tr>
<tr>
    <th scope="row">Attachment</th>
    <td colspan="3"><p class="btn_sky"><a href="#">No Attachment</a></p></td>
</tr>
<tr>
    <th scope="row">Remark</th>
    <td colspan="3"><textarea cols="20" rows="5" disabled="disabled">${orderInvestInfo.invReqRem }</textarea></td>
</tr>
<tr>
    <th scope="row">Request  Date</th>
    <td><span>${orderInvestInfo.invReqCrtDt }</span></td>
    <th scope="row">Request By</th>
    <td><span>${orderInvestInfo.userName }</span></td>
</tr>
<tr>
    <th scope="row">Last Update At</th>
    <td><span>${orderInvestInfo.invReqUpdDt }</span></td>
    <th scope="row">Last Update By</th>
    <td><span>${orderInvestInfo.userName }</span></td>
</tr>
<tr>
    <th scope="row">Response</th>
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
<h2>Customer  Information</h2>
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
    <th scope="row">Customer ID</th>
    <td><span>${orderCustomerInfo.custId }</span></td>
    <th scope="row">Customer Type</th>
    <td><span>${orderCustomerInfo.codeDesc }</span></td>
</tr>
<tr>
    <th scope="row">Customer Name</th>
    <td><span>${orderCustomerInfo.name }</span></td>
    <th scope="row">Customer NRIC</th>
    <td><span>${orderCustomerInfo.nric }</span></td>
</tr>
</tbody>
</table><!-- table end -->

<aside class="title_line"><!-- title_line start -->
<h2>Mailing Information </h2>
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
    <th scope="row">Contact Person</th>
    <td colspan="3"><span>${orderCustomerInfo.custcntIdName }</span></td>
</tr>
<tr>
    <th scope="row">Office No.</th>
    <td><span>${orderCustomerInfo.custcntTelO }</span></td>
    <th scope="row">Residence No.</th>
    <td><span>${orderCustomerInfo.custcntTelR }</span></td>
</tr>
<tr>
    <th scope="row">Fax No.</th>
    <td><span>${orderCustomerInfo.custcntTelF }</span></td>
    <th scope="row">Mobile No.</th>
    <td><span>${orderCustomerInfo.custcntTelM1 }</span></td>
</tr>
<tr>
    <th scope="row">Address</th>
    <td colspan="3"><span>${orderCustomerInfo.custaddAddr }</span></td>
</tr>
</tbody>
</table><!-- table end -->

<aside class="title_line"><!-- title_line start -->
<h2>Installation Information </h2>
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
    <th scope="row">Contact Person</th>
    <td colspan="3"><span>${orderCustomerInfo.cntIdName }</span></td>
</tr>
<tr>
    <th scope="row">Office No.</th>
    <td><span>${orderCustomerInfo.cntTelO }</span></td>
    <th scope="row">Residence No.</th>
    <td><span>${orderCustomerInfo.cntTelR }</span></td>
</tr>
<tr>
    <th scope="row">Fax No.</th>
    <td><span>${orderCustomerInfo.cntTelF }</span></td>
    <th scope="row">Mobile No.</th>
    <td><span>${orderCustomerInfo.cntTelM1 }</span></td>
</tr>
<tr>
    <th scope="row">Address</th>
    <td colspan="3"><span>${orderCustomerInfo.addAddr }</span></td>
</tr>
</tbody>
</table><!-- table end -->

</article><!-- tap_area end -->

</section><!-- tap_wrap end -->

<aside class="title_line"><!-- title_line start -->
<h2>Investigation Request Result Information</h2>
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
    <th scope="row">Status</th>
    <td>
    <select id="statusPop" name="statusPop" onchange="fn_stusChange()">
        <option value="44">Pending</option>
        <option value="5">Approve</option>
        <option value="6">Reject</option>
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
    <th scope="row" rowspan="2">Inchage Person</th>
    <td>
    <select id="incharge" name="incharge" onchange="fn_inCharge('inchargeNm', this.value, '', '')">
        <option value="0">[Select One]</option>
        <option value="3">Internal Caller</option>
        <option value="4">Third Party</option>
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
    <th scope="row">Reject Reason</th>
    <td>
        <select id="cmbRejReason" name="cmbRejReason">
           <c:forEach var="list" items="${cmbRejReasonList }">
               <option value="${list.resnId }">${list.resnDesc }</option>
           </c:forEach>
        </select>
    <label><input type="checkbox" id="cancelBs" name="cancelBs"/><span>Cancel BS(Current)</span></label>
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
    <th scope="row">Remark</th>
    <td>
    <textarea cols="20" id="statusRem" name="statusRem" rows="5" placeholder="" ></textarea>
    </td>
</tr>
</tbody>
</table><!-- table end -->
</form>
<ul class="center_btns">
    <li><p class="btn_blue2 big"><a href="#" onclick="fn_saveInvest();">SAVE</a></p></li> 
</ul>
</div>

</section><!-- pop_body end -->

</div><!-- popup_wrap end -->