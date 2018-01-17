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
        var custNm = '${custBasicMap.name}';
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
    		
    		Common.alert("* Please Select the customer type. ");
            return false;
    	}
    	
    	//FeedBack
    	/* if( '' == $("#_reasonCodeConfirm").val() || null == $("#_reasonCodeConfirm").val()){
    		Common.alert("* Please Select the Feedback Code. ");
            return false;
    	} */
    	
    	//Call Message
    	if( '' == $("#_cfCallMessage").val() || null == $("#_cfCallMessage").val()){
    		
    		Common.alert("* Please key in the call message. ");
    		return false;
    		
    	}
         
    	return true;
    }
    
    
    function createCallGrid(){
        
        var  columnLayout = [
                             {dataField : "code", headerText : "Status", width : "10%" , editable : false},
                             {dataField : "cnfmLogMsg", headerText : "Call Message", width : "35%" , editable : false},
                             {dataField : "cnfmLogSmsMsg", headerText : "SMS Message", width : "35%" , editable : false},
                             {dataField : "userName", headerText : "Key By", width : "10%" , editable : false},
                             {dataField : "cnfmLogCrtDt", headerText : "Key At", width : "10%" , editable : false}
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
                               noDataMessage       : "No transaction found in this call.",
                               groupingMessage     : "Here groupping"
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

<form id="ajaxForm">
    <input type="hidden" name="cnfmCntrctId" value="${cnfmCntrctId}">
</form>
<header class="pop_header"><!-- pop_header start -->
<h1>CCP RentalMembership Comfirm Result</h1>
<ul class="right_opt">
    <li><p class="btn_blue2"><a href="#">CLOSE</a></p></li>
</ul>
</header><!-- pop_header end -->

<section class="pop_body"><!-- pop_body start -->

<article class="acodi_wrap"><!-- acodi_wrap start -->
<dl>
    <dt class="click_add_on on"><a href="#">Call Log Info</a></dt>
    <dd>

    <table class="type1"><!-- table start -->
    <caption>table</caption>
    <colgroup>
        <col style="width:180px" />
        <col style="width:*" />
    </colgroup>
    <tbody>
    <tr>
        <th scope="row">Membership Status</th>
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
    <dt class="click_add_on"><a href="#">Order Basic Info</a></dt>
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
        <th scope="row">Order No</th>
        <td><span>${orderInfoMap.ordNo}</span></td>
        <th scope="row">Order Date</th>
        <td><span>${orderInfoMap.ordDt}</span></td>
        <th scope="row">Order Status</th>
        <td><span>${orderInfoMap.ordStusName}</span></td>
    </tr>
    <tr>
        <th scope="row">Product Category</th>
        <td colspan="3"><span>${orderInfoMap.stkCtgryName}</span></td>
        <th scope="row">Application Type</th>
        <td><span>${orderInfoMap.appTypeCode}</span></td>
    </tr>
    <tr>
        <th scope="row">Product Code</th>
        <td><span>${orderInfoMap.stockCode}</span></td>
        <th scope="row">Product Name</th>
        <td colspan="3"><span>${orderInfoMap.stockDesc}</span></td>
    </tr>
    <tr>
        <th scope="row">Last Nembership</th>
        <td colspan="3"><span>${cofigMap.lastMembership}</span></td>
        <th scope="row">Expire Date</th>
        <td><span>${cofigMap.srvPrdExprDt}</span></td>
    </tr>
    </tbody>
    </table><!-- table end -->

    </dd>
    <dt class="click_add_on"><a href="#">Customer Basic Info</a></dt>
    <dd>

    <aside class="title_line"><!-- title_line start -->
    <h2>Customer Basic Info</h2>
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
        <th scope="row">Customer Name</th>
        <td><span>${custBasicMap.name}</span></td>
        <th scope="row">NRIC / Company No.</th>
        <td><span>${custBasicMap.nric}</span></td>
    </tr>
    </tbody>
    </table><!-- table end -->

    <aside class="title_line"><!-- title_line start -->
    <h2>Installation Address</h2>
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
        <th scope="row">Installation Address</th>
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
    <h2>Rental Pay Setting</h2>
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
        <th scope="row">Payment Mode</th>
        <td><span>${payMap.codeName }</span></td>
        <th scope="row">Name On Card</th>
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
        <th scope="row">Credit Card No.</th>
        <td><span>
        <c:if test="${empty payMap.custCrcNo }">
            -
        </c:if>
        <c:if test="${not empty payMap.custCrcNo }">
            ${payMap.custCrcNo}
        </c:if>
        </span></td>
        <th scope="row">Card Type</th>
        <td><span>
         <c:if test="${empty payMap.codeName1}">
           -
	    </c:if>
	    <c:if test="${not empty payMap.codeName1}">
	        ${payMap.codeName1}
	    </c:if>
        </span></td>
        <th scope="row">Expiry Date</th>
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
        <th scope="row">Bank Acc No.</th>
        <td><span>
        <c:if test="${empty payMap.custAccNo}">
        -
	    </c:if>
	    <c:if test="${not empty payMap.custAccNo}">
	        ${payMap.custAccNo}
	    </c:if>
        </span></td>
        <th scope="row">Issue Bank</th>
        <td><span>
        <c:if test="${not empty payMap.bankCode}">
        ${payMap.bankCode}
	    </c:if>
	    <c:if test="${not empty payMap.bankName}">
	        - ${payMap.bankName}
	    </c:if>
        </span></td>
        <th scope="row">Account Name</th>
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
        <th scope="row">Pay By Third Party</th>
        <td><span>
        <c:if test="${payMap.is3rdParty eq 0}">
        No
	    </c:if>
	    <c:if test="${payMap.is3rdParty eq 1}">
	        Yes
	    </c:if>
        </span></td>
        <th scope="row">Third Party ID</th>
        <td><span>
        <c:if test="${not empty thirdMap}">
            ${thirdMap.custId}
        </c:if>
        <c:if test="${empty thirdMap}">
            -
        </c:if>
        </span></td>
        <th scope="row">Third Party Type</th>
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
        <th scope="row">Third Party Name</th>
        <td colspan="3"><span>
         <c:if test="${not empty thirdMap}">
           ${thirdMap.name}
	     </c:if>
	     <c:if test="${empty thirdMap}">
	           -
	     </c:if>
        </span></td>
        <th scope="row">Third Party NRIC</th>
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
        <th scope="row">Apply Date</th>
        <td><span>${payMap.ddApplyDt}</span></td>
        <th scope="row">Submit Date</th>
        <td><span>${payMap.ddSubmitDt}</span></td>
        <th scope="row">Start Date</th>
        <td><span>${payMap.ddStartDt}</span></td>
    </tr>
    <tr>
        <th scope="row">Reject Date</th>
        <td><span>${payMap.ddRejctDt}</span></td>
        <th scope="row">Reject Code</th> 
        <td><span>${payMap.resnCode}</span></td>
        <th scope="row">Payment Term</th>
        <td><span>
        <c:if test="${not empty payMap.payTrm}">
        ${payMap.payTrm} month(s)
        </c:if>
        </span></td>
    </tr>
    </tbody>
    </table><!-- table end -->

    <aside class="title_line"><!-- title_line start -->
    <h2>Contact Person</h2>
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
        <th scope="row">Contact Person Name</th>
        <td><span>${contactMap.name }</span></td>
    </tr>
    <tr>
        <th scope="row">Mobile No.</th>
        <td><span>${contactMap.telM1 }</span></td>
        <th scope="row">Office No.</th>
        <td><span>${contactMap.telO }</span></td>
        <th scope="row">House No.</th>
        <td><span>${contactMap.telR }</span></td>
    </tr>
    </tbody>
    </table><!-- table end -->

    </dd>
</dl>
</article><!-- acodi_wrap end -->

<aside class="title_line"><!-- title_line start -->
<h2>Membership Info</h2>
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
    <th scope="row">Membership Status</th>
    <td>
    <select class="w100p" name="updMemStatus">
        <option value="44" selected="selected">Pending</option>
        <option value="5">Approved</option>
        <option value="10">Cancelled</option>
    </select>
    </td>
    <th scope="row">Customer Type</th>
    <td>
    <select class="w100p" id="_custTypeConfirm" name="updCustType"></select>
    </td>
</tr>
<tr>
    <th scope="row">Membership F/B Code</th>
    <td>
    <select class="w100p" id="_reasonCodeConfirm" name="updReasonCode"></select>
    </td>
    <th scope="row">Membership Type</th>
    <td>
    <select class="w100p" name="updMemType">
        <option value="1313" selected="selected">Rental</option>
        <option value="1314">Staff</option>
    </select>
    </td>
</tr>
<tr>
    <th scope="row">Remark</th>
    <td colspan="3"><textarea cols="20" rows="5" name="updRemark" placeholder="remark">${confirmResultMap.cnfmRem }</textarea></td>
</tr>
<tr>
    <th scope="row">P &amp; C Remark</th>
    <td colspan="3"><textarea cols="20" rows="5" name="updPncRemark" placeholder="P & C Remark">${confirmResultMap.cnfmPncRem }</textarea></td> 
</tr>
</tbody>
</table><!-- table end -->

<aside class="title_line"><!-- title_line start -->
<h2>Call Info</h2>
</aside><!-- title_line end -->

<table class="type1"><!-- table start -->
<caption>table</caption>
<colgroup>
    <col style="width:180px" />
    <col style="width:*" />
</colgroup>
<tbody>
<tr>
    <th scope="row">Call Message<span class="must">*</span></th>
    <td><textarea cols="20" rows="5" id="_cfCallMessage" name="updCallMsg" placeholder="Call Message"></textarea></td>
</tr>
</tbody>
</table><!-- table end -->

<aside class="title_line"><!-- title_line start -->
<h2>SMS Info</h2>
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
    <label><input type="checkbox"  id="_updSmsChk" /><span>Send SMS ?</span></label>
    </td>
</tr>
<tr>
    <th scope="row">SMS Message</th>
    <td><textarea cols="20" rows="5" name="updSmsMsg" id="_updSmsMsg" placeholder="SMS Message" disabled="disabled" ></textarea></td>
</tr>
 <tr>   
    <td colspan="2"><span id="_charCounter">Total Character(s) :</span></td>
 </tr>
</tbody>
</table><!-- table end -->

</form>
</section><!-- search_table end -->

<ul class="center_btns">
    <li><p class="btn_blue2 big"><a id="_confirmSave">SAVE</a></p></li>
</ul>

</section><!-- pop_body end -->

</div><!-- popup_wrap end -->

