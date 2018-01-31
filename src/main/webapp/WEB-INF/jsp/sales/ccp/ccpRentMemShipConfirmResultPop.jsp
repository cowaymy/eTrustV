<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>
<script type="text/javascript">
    
$(function() {
    $('#_updSmsMsg').keyup(function (e){
        
        var content = $(this).val();
        
       // $(this).height(((content.split('\n').length + 1) * 2) + 'em');
        
        $('#_charCounter').html('Total Character(s) : '+content.length);
    });
    $('#_updSmsMsg').keyup();
});
    //생성 후 반환 Grid Id
    var callGrid;
    $(document).ready(function() {
    	
    	//Create Grid
    	createCallGrid();
    	
    	//Ajax Call
    	fn_selectCallListAjax();
    	
    	//params Setting
    	var tempCustTypeVal = $("#_cfCustType").val();
    	var tempFeedbackVal = $("#_cfFeedbackId").val();
    	
    	//ComboBox
    	doGetCombo('/common/selectCodeList.do', '8', tempCustTypeVal ,'_custTypeConfirm', 'S' , ''); //Cust Type
    	doGetCombo('/sales/ccp/getReasonCodeList', '', tempFeedbackVal,'_reasonCodeConfirm', 'S' , ''); //Reason
    	
    	//Save
    	$("#_confirmSave").click(function() {
    		
    		//Validation
    		var isValidate = false;
    		
    		isValidate = fn_confirmValidation();
    		
    		if(isValidate == false){
    			return ;
    		}
    		
    		//Validation Success And Save
    		//Sms Msg Check
    		
    		fn_confirmResultSaveFunc();
    		
    		
		});
    	
    	
    	 $("#_updSmsChk").change(function() {
    		   
    		 $("#_updSmsMsg").val('');
    	     $("#_updSmsMsg").attr("disabled" , "disabled");
    		 
    	     if($("#_updSmsChk").is(":checked") == true){
	             $("#_updSmsMsg").attr("disabled" , false);
	             $("#_updMsgIsChk").val("1");
	             fn_setSMSmsg();
    	      }else{
    	    	  $("#_updMsgIsChk").val("0");
    	      }
    	 });
    	
    }); //Document Ready Func End
    
    
    function fn_setSMSmsg(){
        var msg = '';
        var ordNo = '${orderInfoMap.ordNo}';
        var custNm = $("#_custHiddName").val();
        var stus = '${confirmResultMap.name }';
        msg += "ORDER : " + ordNo + "\r\n";
        msg += "NAME : " + custNm + "\r\n";
        msg += "M/SHIP STATUS : " + stus;
        $("#_updSmsMsg").val(msg);  
        $('#_charCounter').html('Total Character(s) : '+ msg.length);
    }
    
    //Msg Check Change Func
/*     function  fn_smsChkFunc(){
    	
    	if($("#_updSmsChk").is(":checked") == true){
            $("#_updMsgIsChk").val("1");
        }else{
            $("#_updMsgIsChk").val("0");
        }
    	
    } */
    
    //Save
    function fn_confirmResultSaveFunc(){
    	
    	Common.ajax("GET", "/sales/ccp/insUpdConfrimResult.do", $("#_cfSaveForm").serialize(), function(result){
    		
    		  Common.alert(result.message);
    		  $("#_btnSearch").click();
    		  $("#_confirmSave").css("display" , "none");
    		
    	});
    }
    
    
    function fn_confirmValidation(){
    	
    	//Customer Type
    	if( '' == $("#_custTypeConfirm").val() || null == $("#_custTypeConfirm").val()){
    		
    		Common.alert('<spring:message code="sal.alert.msg.plzSelCustType" />');
            return false;
    	}
    	
    	//FeedBack
    	console.log('$("#_updMemStatus option:selected").val() : ' + $("#_updMemStatus option:selected").val());
     	if($("#_updMemStatus option:selected").val() != "5"){
     		if( '' == $("#_reasonCodeConfirm").val() || null == $("#_reasonCodeConfirm").val()){
                Common.alert('<spring:message code="sal.alert.msg.plzSelFeedbackCode" />');
                return false;
            }	
    	}
    	
    	//Call Message
    	if( '' == $("#_cfCallMessage").val() || null == $("#_cfCallMessage").val()){
    		
    		Common.alert('<spring:message code="sal.alert.msg.plzKeyInCallMsg" />');
    		return false;
    		
    	}
         
    	return true;
    }
    
    
    function createCallGrid(){
        
        var  columnLayout = [
                             {dataField : "code", headerText : '<spring:message code="sal.title.status" />', width : "10%" , editable : false},
                             {dataField : "cnfmLogMsg", headerText : '<spring:message code="sal.title.text.callMsg" />', width : "35%" , editable : false},
                             {dataField : "cnfmLogSmsMsg", headerText : '<spring:message code="sal.title.text.smsMsg" />', width : "35%" , editable : false},
                             {dataField : "userName", headerText : '<spring:message code="sal.title.text.keyBy" />', width : "10%" , editable : false},
                             {dataField : "cnfmLogCrtDt", headerText : '<spring:message code="sal.title.text.keyAt" />', width : "10%" , editable : false}
                       ]
                       
                       //그리드 속성 설정
                       var gridPros = {
                               usePaging           : true,         //페이징 사용
                               pageRowCount        : 5,           //한 화면에 출력되는 행 개수 20(기본값:20)            
                               editable            : false,            
                               fixedColumnCount    : 0,            
                               showStateColumn     : false,             
                               displayTreeOpen     : true,            
          //                     selectionMode       : "singleRow",  //"multipleCells",            
                               headerHeight        : 30,       
                               rowHeight           : 150,   
                               wordWrap            : true, 
                               useGroupingPanel    : false,        //그룹핑 패널 사용
                               skipReadonlyColumns : true,         //읽기 전용 셀에 대해 키보드 선택이 건너 뛸지 여부
                               wrapSelectionMove   : true,         //칼럼 끝에서 오른쪽 이동 시 다음 행, 처음 칼럼으로 이동할지 여부
                               showRowNumColumn    : false,         //줄번호 칼럼 렌더러 출력    
                               noDataMessage       : '<spring:message code="sal.title.text.noTransacFoundThisCall" />'
                           };
                       
        callGrid = GridCommon.createAUIGrid("#call_grid_wrap", columnLayout, gridPros);
    }
    
    function fn_selectCallListAjax(){
        Common.ajax("GET", "/sales/ccp/selectCallLogList",  $("#ajaxForm").serialize(), function(result) {
            AUIGrid.setGridData(callGrid, result);
            
       });
    }
    
</script>
<div id="popup_wrap" class="popup_wrap"><!-- popup_wrap start -->
<!-- hiddenValues -->
<input type="hidden" id="_cfCustType" value="${confirmResultMap.cnfmCustTypeId}"> 
<input type="hidden" id="_cfFeedbackId" value="${confirmResultMap.cnfmFdbckId}">
<input type="hidden" id="_custHiddName" value="${custBasicMap.name}">


<form id="ajaxForm">
    <input type="hidden" name="cnfmCntrctId" value="${cnfmCntrctId}">
</form>
<header class="pop_header"><!-- pop_header start -->
<h1><spring:message code="sal.title.text.ccpRentalMemConfirmResult" /></h1>
<ul class="right_opt">
    <li><p class="btn_blue2"><a href="#"><spring:message code="sal.btn.close" /></a></p></li>
</ul>
</header><!-- pop_header end -->

<section class="pop_body"><!-- pop_body start -->

<article class="acodi_wrap"><!-- acodi_wrap start -->
<dl>
    <dt class="click_add_on on"><a href="#"><spring:message code="sal.title.text.callLogInfo" /></a></dt>
    <dd>

    <table class="type1"><!-- table start -->
    <caption>table</caption>
    <colgroup>
        <col style="width:180px" />
        <col style="width:*" />
    </colgroup>
    <tbody>
    <tr>
        <th scope="row"><spring:message code="sal.title.text.memShipStus" /></th>
        <td>${confirmResultMap.name }</td>
    </tr>
    </tbody>
    </table><!-- table end -->

<!--     <ul class="right_btns">
        <li><p class="btn_grid"><a href="#">EDIT</a></p></li>
        <li><p class="btn_grid"><a href="#">NEW</a></p></li>
        <li><p class="btn_grid"><a href="#">EXCEL UP</a></p></li>
        <li><p class="btn_grid"><a href="#">EXCEL DW</a></p></li>
        <li><p class="btn_grid"><a href="#">DEL</a></p></li>
        <li><p class="btn_grid"><a href="#">INS</a></p></li>
        <li><p class="btn_grid"><a href="#">ADD</a></p></li>
    </ul> -->

    <article class="grid_wrap"><!-- grid_wrap start -->
    <div id="call_grid_wrap" style="width:100%; height:180px; margin:0 auto;"></div>
    </article><!-- grid_wrap end -->

    </dd>
    <dt class="click_add_on"><a href="#"><spring:message code="sal.title.text.ordBasicInfo" /></a></dt>
    <dd>

    <table class="type1"><!-- table start -->
    <caption>table</caption>
    <colgroup>
        <col style="width:180px" />
        <col style="width:*" />
        <col style="width:180px" />
        <col style="width:*" />
        <col style="width:180px" />
        <col style="width:*" />
    </colgroup>
    <tbody>
    <tr>
        <th scope="row"><spring:message code="sal.text.ordNo" /></th>
        <td><span>${orderInfoMap.ordNo}</span></td>
        <th scope="row"><spring:message code="sal.text.ordDate" /></th>
        <td><span>${orderInfoMap.ordDt}</span></td>
        <th scope="row"><spring:message code="sal.title.text.ordStus" /></th>
        <td><span>${orderInfoMap.ordStusName}</span></td>
    </tr>
    <tr>
        <th scope="row"><spring:message code="sal.title.text.productCategory" /></th>
        <td colspan="3"><span>${orderInfoMap.stkCtgryName}</span></td>
        <th scope="row"><spring:message code="sal.text.appType" /></th>
        <td><span>${orderInfoMap.appTypeCode}</span></td>
    </tr>
    <tr>
        <th scope="row"><spring:message code="sal.text.productCode" /></th>
        <td><span>${orderInfoMap.stockCode}</span></td>
        <th scope="row"><spring:message code="sal.title.productName" /></th>
        <td colspan="3"><span>${orderInfoMap.stockDesc}</span></td>
    </tr>
    <tr>
        <th scope="row"><spring:message code="sal.text.lastMem" /></th>
        <td colspan="3"><span>${cofigMap.lastMembership}</span></td>
        <th scope="row"><spring:message code="sal.title.expireDate" /></th>
        <td><span>${cofigMap.srvPrdExprDt}</span></td>
    </tr>
    </tbody>
    </table><!-- table end -->

    </dd>
    <dt class="click_add_on"><a href="#"><spring:message code="sal.title.text.custBasicInfo" /></a></dt>
    <dd>

    <aside class="title_line"><!-- title_line start -->
    <h2><spring:message code="sal.title.text.custBasicInfo" /></h2>
    </aside><!-- title_line end -->

    <table class="type1"><!-- table start -->
    <caption>table</caption>
    <colgroup>
        <col style="width:180px" />
        <col style="width:*" />
        <col style="width:180px" />
        <col style="width:*" />
    </colgroup>
    <tbody>
    <tr>
        <th scope="row"><spring:message code="sal.text.custName" /></th>
        <td><span>${custBasicMap.name}</span></td>
        <th scope="row"><spring:message code="sal.title.text.nricCompNo" /></th>
        <td><span>${custBasicMap.nric}</span></td>
    </tr>
    </tbody>
    </table><!-- table end -->

    <aside class="title_line"><!-- title_line start -->
    <h2><spring:message code="sal.text.instAddr" /></h2>
    </aside><!-- title_line end -->

    <table class="type1"><!-- table start -->
    <caption>table</caption>
    <colgroup>
        <col style="width:180px" />
        <col style="width:*" />
        <col style="width:180px" />
        <col style="width:*" />
    </colgroup>
    <tbody>
    <tr>
        <th scope="row"><spring:message code="sal.text.instAddr" /></th>
        <td colspan="3"><span>${installMap.fullAddress}</span></td>
    </tr>
    <%-- <tr>
        <th scope="row">Country</th>
        <td><span>${installMap.country}</span></td>
        <th scope="row">State</th>
        <td><span>${installMap.state}</span></td>
    </tr>
    <tr>
        <th scope="row">City</th>
        <td><span>${installMap.city}</span></td>
        <th scope="row">AreaPostcode</th>
        <td><span>${installMap.postcode}</span></td>
    </tr> --%>
    </tbody>
    </table><!-- table end -->

    <aside class="title_line"><!-- title_line start -->
    <h2><spring:message code="sal.title.text.rentalPaySetting" /></h2>
    </aside><!-- title_line end -->

    <table class="type1"><!-- table start -->
    <caption>table</caption>
    <colgroup>
        <col style="width:180px" />
        <col style="width:*" />
        <col style="width:180px" />
        <col style="width:*" />
        <col style="width:180px" />
        <col style="width:*" />
    </colgroup>
    <tbody>
    <tr>
        <th scope="row"><spring:message code="sal.text.payMode" /></th>
        <td><span>${payMap.codeName }</span></td>
        <th scope="row"><spring:message code="sal.text.nameOnCard" /></th>
        <td colspan="3"><span>
        <c:if test="${empty payMap.custCrcOwner}">
              -
	   </c:if>
	   <c:if test="${not empty payMap.custCrcOwner}">
	       ${payMap.custCrcOwner}
	   </c:if>
        </span></td>
    </tr>
    <tr>
        <th scope="row"><spring:message code="sal.text.creditCardNo" /></th>
        <td><span>
        <c:if test="${empty payMap.custCrcNo }">
            -
        </c:if>
        <c:if test="${not empty payMap.custCrcNo }">
            ${payMap.custCrcNo}
        </c:if>
        </span></td>
        <th scope="row"><spring:message code="sal.text.cardType" /></th>
        <td><span>
         <c:if test="${empty payMap.codeName1}">
           -
	    </c:if>
	    <c:if test="${not empty payMap.codeName1}">
	        ${payMap.codeName1}
	    </c:if>
        </span></td>
        <th scope="row"><spring:message code="sal.text.expiryDate" /></th>
        <td><span>
        <c:if test="${not empty payMap.custCrcExpr}">
         ${payMap.custCrcExpr}
	    </c:if>
	    <c:if test="${empty payMap.custCrcExpr}">
	        -
	    </c:if>
        </span></td>
    </tr>
    <tr>
        <th scope="row"><spring:message code="sal.text.bankAccNo" /></th>
        <td><span>
        <c:if test="${empty payMap.custAccNo}">
        -
	    </c:if>
	    <c:if test="${not empty payMap.custAccNo}">
	        ${payMap.custAccNo}
	    </c:if>
        </span></td>
        <th scope="row"><spring:message code="sal.text.issueBank" /></th>
        <td><span>
        <c:if test="${not empty payMap.bankCode}">
        ${payMap.bankCode}
	    </c:if>
	    <c:if test="${not empty payMap.bankName}">
	        - ${payMap.bankName}
	    </c:if>
        </span></td>
        <th scope="row"><spring:message code="sal.text.accName" /></th>
        <td><span>
        <c:if test="${empty payMap.custAccOwner}">
        -
	    </c:if>
	    <c:if test="${not empty payMap.custAccOwner}">
	        ${payMap.custAccOwner}
	    </c:if>
        </span></td>
    </tr>
    <tr>
        <th scope="row"><spring:message code="sal.text.payByThirdParty" /></th>
        <td><span>
        <c:if test="${payMap.is3rdParty eq 0}">
            <spring:message code="sal.title.text.no" />
	    </c:if>
	    <c:if test="${payMap.is3rdParty eq 1}">
	        <spring:message code="sal.title.text.yes" />
	    </c:if>
        </span></td>
        <th scope="row"><spring:message code="sal.text.thirdPartyId" /></th>
        <td><span>
        <c:if test="${not empty thirdMap}">
            ${thirdMap.custId}
        </c:if>
        <c:if test="${empty thirdMap}">
            -
        </c:if>
        </span></td>
        <th scope="row"><spring:message code="sal.text.thirdPartyType" /></th>
        <td><span>
        <c:if test="${not empty thirdMap}">
            ${thirdMap.codeName1}
         </c:if>
         <c:if test="${empty thirdMap}">
                -
         </c:if>
        </span></td>
    </tr>
    <tr>
        <th scope="row"><spring:message code="sal.text.thirdPartyName" /></th>
        <td colspan="3"><span>
         <c:if test="${not empty thirdMap}">
           ${thirdMap.name}
	     </c:if>
	     <c:if test="${empty thirdMap}">
	           -
	     </c:if>
        </span></td>
        <th scope="row"><spring:message code="sal.text.thirdPartyNric" /></th>
        <td><span>
        <c:if test="${not empty thirdMap}">
           ${thirdMap.nric}
	     </c:if>
	     <c:if test="${empty thirdMap}">
	           -
	     </c:if>
        </span></td>
    </tr>
    <tr>
        <th scope="row"><spring:message code="sal.text.applyDate" /></th>
        <td><span>${payMap.ddApplyDt}</span></td>
        <th scope="row"><spring:message code="sal.text.submitDate" /></th>
        <td><span>${payMap.ddSubmitDt}</span></td>
        <th scope="row"><spring:message code="sal.text.startDate" /></th>
        <td><span>${payMap.ddStartDt}</span></td>
    </tr>
    <tr>
        <th scope="row"><spring:message code="sal.text.rejectDate" /></th>
        <td><span>${payMap.ddRejctDt}</span></td>
        <th scope="row"><spring:message code="sal.text.rejectCode" /></th> 
        <td><span>${payMap.resnCode}</span></td>
        <th scope="row"><spring:message code="sal.text.payTerm" /></th>
        <td><span>
        <c:if test="${not empty payMap.payTrm}">
        ${payMap.payTrm} month(s)
        </c:if>
        </span></td>
    </tr>
    </tbody>
    </table><!-- table end -->

    <aside class="title_line"><!-- title_line start -->
    <h2><spring:message code="sal.tap.title.contactPerson" /></h2>
    </aside><!-- title_line end -->

    <table class="type1"><!-- table start -->
    <caption>table</caption>
    <colgroup>
        <col style="width:180px" />
        <col style="width:*" />
        <col style="width:180px" />
        <col style="width:*" />
        <col style="width:180px" />
        <col style="width:*" />
    </colgroup>
    <tbody>
    <tr>
        <th scope="row"><spring:message code="sal.title.text.contactPersonName" /></th>
        <td><span>${contactMap.name }</span></td>
    </tr>
    <tr>
        <th scope="row"><spring:message code="sal.title.text.mobileNo" /></th>
        <td><span>${contactMap.telM1 }</span></td>
        <th scope="row"><spring:message code="sal.title.text.officeNo" /></th>
        <td><span>${contactMap.telO }</span></td>
        <th scope="row"><spring:message code="sal.title.text.houseNop" /></th>
        <td><span>${contactMap.telR }</span></td>
    </tr>
    </tbody>
    </table><!-- table end -->

    </dd>
</dl>
</article><!-- acodi_wrap end -->

<aside class="title_line"><!-- title_line start -->
<h2><spring:message code="sal.title.text.memshipInfo" /></h2>
</aside><!-- title_line end -->

<section class="search_table"><!-- search_table start -->
<form id="_cfSaveForm">
<input type="hidden" name="updCntrcId" value="${cnfmCntrctId}" id="_updCntrcId">
<input type="hidden" name="updCnfmId" value="${confirmResultMap.cnfmId}">
<input type="hidden" name="updMsgIsChk" id="_updMsgIsChk" value="0">
<input type="hidden" name="srvCntrctId" value="${srvCntrctId}">
<input type="hidden" name="updCustTypeId" value="${custBasicMap.typeId }">
<input type="hidden" name="updSalesOrdNo" value="${orderInfoMap.ordNo}"> <!-- ASIS Source Not Exist and TOBE ADDED  -->
<table class="type1"><!-- table start -->
<caption>table</caption>
<colgroup>
    <col style="width:180px" />
    <col style="width:*" />
    <col style="width:180px" />
    <col style="width:*" />
</colgroup>
<tbody>
<tr>
    <th scope="row"><spring:message code="sal.title.text.memShipStus" /></th>
    <td>
    <select class="w100p" name="updMemStatus" id="_updMemStatus">
        <option value="44" selected="selected"><spring:message code="sal.text.pending" /></option>
        <option value="5"><spring:message code="sal.combo.text.approv" /></option>
        <option value="10"><spring:message code="sal.combo.text.cancelled" /></option>
    </select>
    </td>
    <th scope="row"><spring:message code="sal.text.custType" /></th>
    <td>
    <select class="w100p" id="_custTypeConfirm" name="updCustType"></select>
    </td>
</tr>
<tr>
    <th scope="row"><spring:message code="sal.text.memFBcode" /></th>
    <td>
    <select class="w100p" id="_reasonCodeConfirm" name="updReasonCode"></select>
    </td>
    <th scope="row"><spring:message code="sal.text.membershipType" /></th>
    <td>
    <select class="w100p" name="updMemType">
        <option value="1313" selected="selected"><spring:message code="sal.combo.text.rental" /></option>
        <option value="1314"><spring:message code="sal.text.staff" /></option>
    </select>
    </td>
</tr>
<tr>
    <th scope="row"><spring:message code="sal.text.remarks" /></th>
    <td colspan="3"><textarea cols="20" rows="5" name="updRemark" placeholder="remark">${confirmResultMap.cnfmRem }</textarea></td>
</tr>
<tr>
    <th scope="row"><spring:message code="sal.title.text.pncRem" /></th>
    <td colspan="3"><textarea cols="20" rows="5" name="updPncRemark" placeholder="P & C Remark">${confirmResultMap.cnfmPncRem }</textarea></td> 
</tr>
</tbody>
</table><!-- table end -->

<aside class="title_line"><!-- title_line start -->
<h2><spring:message code="sal.title.text.callInfo" /></h2>
</aside><!-- title_line end -->

<table class="type1"><!-- table start -->
<caption>table</caption>
<colgroup>
    <col style="width:180px" />
    <col style="width:*" />
</colgroup>
<tbody>
<tr>
    <th scope="row"><spring:message code="sal.title.text.callMsg" /><span class="must">*</span></th>
    <td><textarea cols="20" rows="5" id="_cfCallMessage" name="updCallMsg" placeholder="Call Message"></textarea></td>
</tr>
</tbody>
</table><!-- table end -->

<aside class="title_line"><!-- title_line start -->
<h2><spring:message code="sal.title.text.smsInfo" /></h2>
</aside><!-- title_line end -->

<table class="type1"><!-- table start -->
<caption>table</caption>
<colgroup>
    <col style="width:180px" />
    <col style="width:*" />
</colgroup>
<tbody>
<tr>
    <td colspan="2">
    <label><input type="checkbox"  id="_updSmsChk" /><span><spring:message code="sal.title.text.sendSmsQuest" /></span></label>
    </td>
</tr>
<tr>
    <th scope="row"><spring:message code="sal.title.text.smsMsg" /></th>
    <td><textarea cols="20" rows="5" name="updSmsMsg" id="_updSmsMsg" placeholder="SMS Message" disabled="disabled" ></textarea></td>
</tr>
 <tr>   
    <td colspan="2"><span id="_charCounter"><spring:message code="sal.title.text.totChars" /></span></td>
 </tr>
</tbody>
</table><!-- table end -->

</form>
</section><!-- search_table end -->

<ul class="center_btns">
    <li><p class="btn_blue2 big"><a id="_confirmSave"><spring:message code="sal.btn.save" /></a></p></li>
</ul>

</section><!-- pop_body end -->

</div><!-- popup_wrap end -->

