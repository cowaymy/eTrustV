<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>
<script type="text/javaScript">

function fn_saveValidation(){
	if($("#callStatus").val() == ''){
        Common.alert("<spring:message code='service.msg.callLog'/> ");
        return false;
    }
	
	if($("#feedBackCode").val() == ''){
        Common.alert("<spring:message code='service.msg.feedback'/> ");
        return false;
    }
    return true;
}

function fn_saveConfirm(){
    if(fn_saveValidation()){
        Common.confirm("<spring:message code='sys.common.alert.save'/>", fn_addCallSave);
    }
}

function fn_addCallSave(){
	Common.ajax("POST", "/callCenter/addCallLogResult.do", $("#addCallForm").serializeJSON(), function(result) {
        console.log("성공.");
        console.log("data : " + result);
        Common.alert(result.message);

        $("#hideContent").hide();
        $("#hideContent1").hide();
        $("#hideContent3").hide();
        $("#hideContent4").hide();
        $("#hiddenBtn").hide();
        
    });
}

function fn_callLogTransaction(){
    Common.ajax("GET", "/callCenter/getCallLogTransaction.do", $("#addCallForm").serialize(), function(result) {
        console.log("성공.");
        console.log("data : " + result);
        AUIGrid.setGridData(callLogTranID, result);
    });
}

$(document).ready(function() {
	callLogTranGrid();
	fn_callLogTransaction();
	
});
var callLogTranID;
function callLogTranGrid() {
    //AUIGrid 칼럼 설정
    var columnLayout = [ {
        dataField : "code",
        headerText : '<spring:message code="service.grid.Status" />',
        editable : false,
        width : 100
    }, {
        dataField : "c1",
        headerText : '<spring:message code="service.grid.RecallDate" />',
        editable : false,
        width : 100
    }, {
        dataField : "c2",
        headerText : '<spring:message code="service.grid.ActionDate" />',        
        editable : false,
        width : 130
    }, {
        dataField : "c9",
        headerText : '<spring:message code="service.grid.Feedback" />',        
        editable : false,
        width : 150
    }, {
        dataField : "c5",
        headerText : '<spring:message code="service.grid.AssignCT" />',        
        editable : false,
        style : "my-column",
        width : 100
    }, {
        dataField : "callRem",
        headerText : "Remark",
        headerText : '<spring:message code="service.grid.Remark" />',               
        editable : false,
        width : 180
    }, {
        dataField : "c3",
        headerText : '<spring:message code="service.grid.KeyBy" />',            
        editable : false,
        width : 180
        
    }, {
        dataField : "callCrtDt",
        headerText : '<spring:message code="service.grid.KeyAt" />',
        width : 180
    }];
     // 그리드 속성 설정
    var gridPros = {
        
        // 페이징 사용       
        usePaging : true,
        
        // 한 화면에 출력되는 행 개수 20(기본값:20)
        pageRowCount : 20,
        
        editable : false,
        
        showStateColumn : true, 
        
        displayTreeOpen : true,
        
        
        headerHeight : 30,
        
        // 읽기 전용 셀에 대해 키보드 선택이 건너 뛸지 여부
        skipReadonlyColumns : true,
        
        // 칼럼 끝에서 오른쪽 이동 시 다음 행, 처음 칼럼으로 이동할지 여부
        wrapSelectionMove : true,
        
        // 줄번호 칼럼 렌더러 출력
        showRowNumColumn : true

    };
    
    //myGridID = GridCommon.createAUIGrid("grid_wrap", columnLayout, gridPros);
    callLogTranID = AUIGrid.create("#grid_wrap_callLogList", columnLayout, gridPros);
}

function fn_doAllaction(){
    var ord_id = $("#salesOrdId").val();
    var  vdte   = $("#requestDate").val();
    var rdcStock = $("#rdcStock").text();
    
   
    if(rdcStock != '0'){
        Common.popupDiv("/organization/allocation/allocation.do" ,{ORD_ID:ord_id  , S_DATE:vdte ,TYPE:'INS'}, null , true , '_doAllactionDiv');
    }
    else{
    	Common.alert("<spring:message code='service.msg.stock'/> ");
    }

}
</script>
<div id="popup_wrap" class="popup_wrap"><!-- popup_wrap start -->

<header class="pop_header"><!-- pop_header start -->
<h1><spring:message code='service.title.NewCallLogResult'/></h1>
<ul class="right_opt">
    <li><p class="btn_blue2"><a href="#"><spring:message code='sys.btn.close'/></a></p></li>
</ul>
</header><!-- pop_header end -->

<section class="pop_body"><!-- pop_body start -->

<article class="acodi_wrap"><!-- acodi_wrap start -->
<dl>
    <dt class="click_add_on on"><a href="#"><spring:message code='service.title.CallLogInformationTransaction'/></a></dt>
    <dd>
    
    <table class="type1"><!-- table start -->
    <caption>table</caption>
    <colgroup>
        <col style="width:140px" />
        <col style="width:*" />
        <col style="width:135px" />
        <col style="width:*" />
    </colgroup>
    <tbody>
    <tr>
        <th scope="row"><spring:message code='service.title.CallLogType'/></th>
        <td>
        <span><c:out value="${orderCall.callTypeName}"/> </span>
        </td>
        <th scope="row"><spring:message code='service.title.CreateDate'/></th>
        <td>
        <span><c:out value="${orderCall.crtDt}"/> </span>
        </td>
         <th scope="row"> </th>
        <td></td>
    </tr>
    <tr>
        <th scope="row"><spring:message code='service.title.WaitForCancel'/></th>
        <c:if test="${orderCall.isWaitCancl == '0' }">
        <td>
        <span>No</span>
        </td>
         </c:if>
         <c:if test="${orderCall.isWaitCancl == '1' }">
        <td>
        <span>Yes</span>
        </td>
         </c:if>
    
    
        <th scope="row"><spring:message code='service.title.Creator'/></th>        
        <td>
        <span><c:out value="${orderCall.crtUserId}"/></span>
        </td>
         <th scope="row"> </th>
        <td></td>
    </tr>
    <tr>
        <th scope="row"><spring:message code='service.title.ProductToInstall'/></th>              
        <td>
        <span><c:out value="${orderCall.productCode}"/> - <c:out value="${orderCall.productName}"/></span>
        </td>
        <th scope="row"><spring:message code='service.title.CallLogStatus'/></th>        
        <td>
           <span><c:out value="${orderCall.callStusCode}"/></span>
        </td>
        <th scope="row"> </th>
        <td></td>
    </tr>
      <tr>
     
        <th scope="row"><spring:message code='service.title.RDCAvailableQty'/></th>        
       <c:if test= "${rdcStock.availQty != null }" >
       <td>
         <span id='rdcStock'><c:out value="${rdcStock.availQty}"/></span>
       </td>
       </c:if>
        <c:if test= "${rdcStock.availQty == null }" >
       <td>
         <span id='rdcStock'>0</span>
       </td>
       </c:if>
        
        <th scope="row"><spring:message code='service.title.InTransitQty'/></th>        
         <c:if test= "${rdcStock.intransitQty != null }" >
        <td>
        <span><c:out value="${rdcStock.intransitQty}"/></span>
        </td>
        </c:if>
          <c:if test= "${rdcStock.intransitQty == null }" >
        <td>
        <span>0</span>
        </td>
        </c:if>
        
        <th scope="row"><spring:message code='service.title.CDCAvailableQty'/></th>        
         <c:if test= "${cdcAvaiableStock.availQty  == null }" >
        <td>
        <span>0</span>
        </td>
        </c:if>
        <c:if test= "${cdcAvaiableStock.availQty != null }" >
        <td>
        <span ><c:out value="${cdcAvaiableStock.availQty}"/></span>
        </td>
        </c:if>
    </tr>
    </tbody>
    </table><!-- table end -->
    
    <article class="grid_wrap mt20"><!-- grid_wrap start -->
    <div id="grid_wrap_callLogList" style="width: 100%; height: 250px; margin: 0 auto;"></div>
    </article><!-- grid_wrap end -->

    </dd>
    <dt class="click_add_on"><a href="#"><spring:message code='service.title.OrderFullDetails'/></a></dt>
    <dd>
    <!------------------------------------------------------------------------------
    Order Detail Page Include START
------------------------------------------------------------------------------->
<%@ include file="/WEB-INF/jsp/sales/order/orderDetailContent.jsp" %>
<!------------------------------------------------------------------------------
    Order Detail Page Include END
------------------------------------------------------------------------------->
    </dd>
</dl>
</article><!-- acodi_wrap end -->

<aside class="title_line mt20" id="hideContent3"><!-- title_line start -->
<h2><spring:message code='service.title.DSCVerificationRemark'/></h2> 
</aside><!-- title_line end -->

<table class="type1" id="hideContent"><!-- table start -->
<caption>table</caption>
<colgroup>
    <col style="width:130px" />
    <col style="width:*" />
</colgroup>
<tbody>
<tr>
    <th scope="row"><spring:message code='service.title.VerificationRemark'/></th>
    <td>
    <textarea cols="20" rows="5" placeholder=""></textarea>
    </td>
</tr>
</tbody>
</table><!-- table end -->

<aside class="title_line mt20"  id="hideContent4"><!-- title_line start -->
<h2><spring:message code='service.title.NewCallLogResult'/></h2>
</aside><!-- title_line end -->
<form action="#" id="addCallForm">
<input type="hidden" value="${orderCall.c4}" id="hiddenProductId" name="hiddenProductId"/>
<input type="hidden" value="${orderCall.callStusId}" id="hiddenCallLogStatusId" name="hiddenCallLogStatusId"/>
<input type="hidden" value="${callStusCode}" id="callStusCode" name="callStusCode"/>
<input type="hidden" value="${callStusId}" id="callStusId" name="callStusId"/>
<input type="hidden" value="${salesOrdId}" id="salesOrdId" name="salesOrdId"/>
<input type="hidden" value="${callEntryId}" id="callEntryId" name="callEntryId"/>
<input type="hidden" value="${salesOrdNo}" id="salesOrdNo" name="salesOrdNo"/>

<table class="type1" id="hideContent1"><!-- table start -->
<caption>table</caption>
<colgroup>
    <col style="width:130px" />
    <col style="width:*" />
    <col style="width:130px" />
    <col style="width:*" />
    <col style="width:130px" />
    <col style="width:*" />
    <col style="width:130px" />
    <col style="width:*" />
</colgroup>
<tbody>
<tr>
    <th scope="row"><spring:message code='service.title.CallLogStatus'/><span class="must">*</span></th>
    <td>
    <select class="w100p" id="callStatus" name="callStatus">
        <option value="20">Ready To Install</option>
        <option value="19">Recall</option>
        <option value="30">Waiting For Cancel</option>
    </select>
    </td>
    <th scope="row"><spring:message code='service.title.RecallDate'/></th>
    <td>
    <input type="text" title="Create start Date" placeholder="DD/MM/YYYY" class="j_date w100p"  id="recallDate" name="recallDate"/>
    </td>
    
    <th scope="row"><spring:message code='service.title.RequestDate'/></th>
    <td>
    <input type="text" title="Request Date" placeholder="DD/MM/YYYY" class="j_date w100p"  id="requestDate" name="requestDate" onchange="javascript:fn_doAllaction()"/>
    </td>
    
    
    <th scope="row"><spring:message code='service.title.AppointmentDate'/></th>    
    <td>
    <input type="text" title="Create start Date" placeholder="DD/MM/YYYY"  readonly="readonly"  class="readonly j_date w100p"  id="appDate" name="appDate" />
    </td>
</tr>
<tr>
    <th scope="row"><spring:message code='service.title.CTGroup'/></th>
    <td>
    
    <input type="text" title="" placeholder="" class="readonly w100p" readonly="readonly" id="CTgroup" name="CTgroup"/>
    
   <!--  <select class="w100p" id="CTgroup"  name="CTgroup" >
        <option value="A">A</option>
        <option value="B">B</option>
        <option value="C">C</option>CT Code
    </select> -->
    </td>
    <th scope="row"><spring:message code='service.title.AppointmentSessione'/></th>       
    <td>
        <input type="text" title="" placeholder=""  readonly="readonly"    id="CTSSessionCode" name="CTSSessionCode" class="readonly w100p"/>
    </td>
    
    
    
    <th scope="row"><spring:message code='service.title.FeedbackCode'/><span class="must">*</span></th>
    <td colspan="3">
    <select class="w100p"  id="feedBackCode" name="feedBackCode">
        <option value="">Feedback Code</option>
          <c:forEach var="list" items="${callStatus }" varStatus="status">
           <option value="${list.resnId}">${list.c1}</option>
        </c:forEach>
    </select>
    </td>
</tr>
<tr>
    <th scope="row"><spring:message code='service.title.CTCode'/></th>
    <td>

    <div class="search_100p"><!-- search_100p start -->
    <input type="text" title="" placeholder=""  class="readonly w100p" readonly="readonly"   id="CTCode" name="CTCode"/>
    <input type="hidden" placeholder="" class="w100p" id="CTID" name="CTID"/>
    <%-- <a href="#" class="search_btn" onclick="javascript:fn_doAllaction()"><img src="${pageContext.request.contextPath}/resources/images/common/normal_search.gif" alt="search" /></a> --%>
    </div><!-- search_100p end -->

    </td>
    <th scope="row"><spring:message code='service.title.CTName'/></th>    
    <td colspan="5">
    <input type="text" title="" placeholder="" class="readonly w100p" readonly="readonly" id="CTName" name="CTName"/>
    </td>
</tr>
<tr>
    <th scope="row"><spring:message code='service.title.Remark'/></th>
    <td colspan="7">
    <textarea cols="20" rows="5" placeholder="" id="remark" name="remark"></textarea>
    </td>
</tr>
</tbody>
</table><!-- table end -->
</form>

<ul class="center_btns" id="hiddenBtn">
    <li><p class="btn_blue2 big"><a href="#" onclick="fn_saveConfirm()">Save</a></p></li>
    <li><p class="btn_blue2 big"><a href="#">Clear</a></p></li>
</ul>

</section><!-- pop_body end -->

</div><!-- popup_wrap end -->
