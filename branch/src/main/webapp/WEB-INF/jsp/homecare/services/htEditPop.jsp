<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>

<script type="text/javaScript">

// add by jgkim
var myDetailGridData = null;
  //Combo Data
  var StatusTypeData1 = [{"codeId": "4","codeName": "Completed"},{"codeId": "21","codeName": "Failed"},{"codeId": "10","codeName": "Cancelled"}];

  // AUIGrid 생성 후 반환 ID

  var myDetailGridID2;


  var option = {
    width : "1000px", // 창 가로 크기
    height : "600px" // 창 세로 크기
  };


  function createAUIGrid2(){
    // AUIGrid 칼럼 설정
    var resultColumnLayout = [ {
                                dataField:"resultIsCurr",
                                headerText:"Version",
                                width:100,
                                height:30
                               }, {
                                dataField : "no",
                                headerText : "BSR No",
                                width : 140
                               }, {
                                dataField : "code",
                                headerText : "Status",
                                width : 140
                               }, {
                                dataField : "memCode",
                                headerText : "Member",
                                width : 140
                               }, {
                                dataField : "setlDt",
                                headerText : "Settle Date",
                                width : 140 ,
                                dataType : "date",
                                formatString : "dd/mm/yyyy"
                               }, {
                                dataField : "resultStockUse",
                                headerText : "Has Filter",
                                width : 140
                               }, {
                                dataField : "resultCrtDt",
                                headerText : "Key At",
                                width : 140,
                                dataType : "date",
                                formatString : "dd/mm/yyyy"
                               }, {
                                dataField : "userName",
                                headerText : "Key By",
                                width : 140
                               }, {
                                dataField : "resultId",
                                headerText : "result_id",
                                width : 140,
                                visible:false
                               }
/*                                , {
                                dataField : "undefined",
                                headerText : "View",
                                width : 170,
                                renderer : {
                                             type : "ButtonRenderer",
                                             labelText : "View",
                                             onclick : function(rowIndex, columnIndex, value, item) {

                                               if(item.code == "ACT") {
                                                 Common.alert('Not able to EDIT for the HS order status in Active.');
                                                 return false;
                                               }

                                               /* $("#_schdulId").val(item.schdulId);
                                                  $("#_salesOrdId").val(item.salesOrdId);
                                                  $("#_openGb").val("edit");
                                                  $("#_brnchId").val(item.brnchId);
                                               */

                                            /*   var aaa = AUIGrid.getCellValue(myDetailGridID2, rowIndex,"resultId");
                                               $("#MresultId").val(AUIGrid.getCellValue(myDetailGridID2, rowIndex,"resultId"));
                                               Common.popupDiv("/services/bs/hSMgtResultViewResultPop.do", $("#viewHSResultForm").serializeJSON());

                                             }
                                }
                               } */
                               ];

    // 그리드 속성 설정
    var gridPros = {
      // 페이징 사용
      //usePaging : true,
      // 한 화면에 출력되는 행 개수 20(기본값:20)
      //pageRowCount : 20,
      editable : false,
      //showStateColumn : true,
      //displayTreeOpen : true,
      headerHeight : 30,
      // 읽기 전용 셀에 대해 키보드 선택이 건너 뛸지 여부
      skipReadonlyColumns : true,
      // 칼럼 끝에서 오른쪽 이동 시 다음 행, 처음 칼럼으로 이동할지 여부
      wrapSelectionMove : true,
      // 줄번호 칼럼 렌더러 출력
      showRowNumColumn : true

    };

    //myGridID = GridCommon.createAUIGrid("grid_wrap", columnLayout, gridPros);
    myDetailGridID2 = GridCommon.createAUIGrid("hsResult_grid_wrap", resultColumnLayout,'', gridPros);
  }


  $(document).ready(function() {

    doDefCombo(StatusTypeData1, '' ,'cmbStatusType2', 'S', '');
    console.log("SchdulId : "+$("#hidschdulId").val());

    selSchdulId = $("#hidschdulId").val(); // TypeId
    selSalesOrdId = $("#hidSalesOrdId").val(); // TypeId
    openGb = $("#openGb").val(); // TypeId
    brnchId = $("#brnchId").val(); // TypeId
    hidHsno = $("#hidHsno").val(); // TypeId
    hrResultId = $("#hrResultId").val(); // TypeId

    createAUIGrid2();


    var statusCd = "${basicinfo.stusCodeId}";
    $("#cmbStatusType2 option[value='"+ statusCd +"']").attr("selected", true);

    var failResnCd = "${basicinfo.failResnId}";
    //alert("fail reason : " + failResnCd);
    if (failResnCd != "0"){
      $("#failReason option[value='"+ failResnCd +"']").attr("selected", true);
      //$("#failReason option[value='60']").attr("selected", true);
    } else {
      $("#failReason").find("option").remove();
    }

    var codyIdCd = "${basicinfo.codyId}";
    $("#cmbServiceMem option[value='"+codyIdCd +"']").attr("selected", true);

    var renColctCd = "${basicinfo.renColctId}";

    $("#cmbCollectType option[value='"+renColctCd +"']").attr("selected", true);
    if ($("#_openGb").val() == "view"){
      $("#btnSave").hide();
    }

    if ('${MOD}' =="VIEW") {
      $("#stitle").text("CS - Result View") ;
      $("#editHSResultForm").find("input, textarea, button, select").attr("disabled",true);
    } else {
      $("#stitle").text("CS - Result EDIT")  ;

      if ($("#stusCode").val()==4) {
        $("#editHSResultForm").find("input, textarea, button, select").attr("disabled",false);
        $('#cmbCollectType').removeAttr('disabled');
      }
    }

    // HS Result Information > HS Status 값에 따라 다른 정보 입력 가능 여부 설정
    if ($("#cmbStatusType2").val() == 4) {    // Completed
      $("input[name='settleDt']").attr('disabled', false);
      $("select[name='failReason'] option").remove();

    } else if ($("#cmbStatusType2").val() == 21) {    // Failed

        $('#settleDt').val('');
        $("input[name='settleDt']").attr('disabled', true);

     } else if ($("#cmbStatusType2").val() == 10) {    // Cancelled

        $('#settleDt').val('');
        $("input[name='settleDt']").attr('disabled', true);

     }

     $("#cmbStatusType2").change(function(){



       if ($("#cmbStatusType2").val() == 4) {    // Completed
         $("input[name='settleDt']").attr('disabled', false);
         $("select[name='failReason'] option").remove();

       } else if ($("#cmbStatusType2").val() == 21) {    // Failed

         doGetCombo('/services/bs/selectFailReason.do',  '', '','failReason', 'S' ,  '');
         $('#settleDt').val('');
         $("input[name='settleDt']").attr('disabled', true);

       } else if ($("#cmbStatusType2").val() == 10) {    // Cancelled

         doGetCombo('/services/bs/selectFailReason.do',  '', '','failReason', 'S' ,  '');
         $('#settleDt').val('');
         $("input[name='settleDt']").attr('disabled', true);

       }
     });
  });


    Common.ajax("GET", "/services/bs/selectHistoryHSResult.do",{selSchdulId : selSchdulId}, function(result) {
      console.log("성공 selectHistoryHSResult.");
      console.log("data : " + result);
      AUIGrid.setGridData(myDetailGridID2, result);
    });



  function fn_getOrderDetailListAjax(){
    Common.ajax("GET", "/homecare/sales/htOrderDetailPop.do",{salesOrderId : 'selSalesOrdId'}, function(result) {
      console.log("성공.");
      console.log("data : " + result);
    });
  }

  function fn_UpdateHsResult(){
    if($("#cmbStatusType2").val() == null || $("#cmbStatusType2").val() == '' ) {
      Common.alert("Please Select 'HS Status' ");
      return false;
    }

    if ($("#cmbStatusType2").val() == 4) {    // Completed
      if ($("#settleDt").val() == '' || $("#settleDt").val() == null) {
        Common.alert("<spring:message code='sys.common.alert.validation' arguments='settleDate Type'/>");
        return false;
      }
/*       if ($("#cmbCollectType").val() == '' || $("#cmbCollectType").val() == null) {
        Common.alert("Please Select 'Collection Code'");
        return false;
      } */
    } else if ($("#cmbStatusType2").val() == 21) {    // Failed
      if ($("#failReason").val() == '' || $("#failReason").val() == null) {
        Common.alert("Please Select 'Fail Reason'.");
        return false;
      }
    } else if ($("#cmbStatusType2").val() == 10) {    // Cancelled
      if ($("#failReason").val() == '' || $("#failReason").val() == null) {
        Common.alert("Please Select 'Fail Reason'.");
        return false;
      }

    }
    Common.ajax("POST", "/homecare/services/UpdateHsResult2.do", $("#editHSResultForm").serializeJSON(), function(result) {

      Common.alert(result.message, fn_parentReload);
      $("#popClose").click();
    });
  }

  function fn_parentReload() {
    fn_getBSListAjax(); //parent Method (Reload)
  }

  //resize func (tab click)
  function fn_resizefunc(obj, gridName){
    var $this = $(obj);
    var width = $this.width();

    AUIGrid.resize(gridName, width, 200);
    // AUIGrid.resize(gridName, width, height);

    // setTimeout(function(){
    // AUIGrid.resize(gridName);
    // }, 100);
  }

</script>

<div id="popup_Editwrap" class="popup_wrap"><!-- popup_wrap start -->

<header class="pop_header"><!-- pop_header start -->

<h1>  <spin id='stitle'>  </spin></h1>
<ul class="right_opt">
    <li><p class="btn_blue2"><a href="#"  id="btnSave" name="btnSave" onclick="fn_UpdateHsResult()">SAVE</a></p></li>
    <li><p class="btn_blue2"><a href="#" id="popClose">CLOSE</a></p></li>
</ul>
</header><!-- pop_header end -->

<section class="pop_body"><!-- pop_body start -->
<form action="#" id="viewHSResultForm" method="post">
    <input type="hidden" name="MresultId" id="MresultId"/>
<aside class="title_line"><!-- title_line start -->
<h2>CS Information</h2>
</aside><!-- title_line end -->

<table class="type1"><!-- table start -->
<caption>table</caption>
<colgroup>
    <col style="width:90px" />
    <col style="width:*" />
    <col style="width:110px" />
    <col style="width:*" />
    <col style="width:110px" />
    <col style="width:*" />
</colgroup>
<tbody>
<tr>
    <th scope="row">CS No</th>
    <td><span><c:out value="${basicinfo.no}"/></span></td>
    <th scope="row">CS Month</th>
    <td><span><c:out value="${basicinfo.monthy}"/></span></td>
    <th scope="row">CS Type</th>
    <td><span><c:out value="${basicinfo.codeName}"/></span></td>
     <th scope="row">Current BSR No</th>
    <td><span><c:out value="${basicinfo.c1}"/></span></td>
</tr>
<%-- <tr>
    <th scope="row">Current BSR No</th>
    <td><span><c:out value="${basicinfo.c1}"/></span></td>
    <th scope="row">Prev HS Area</th>
    <td><span><c:out value="${basicinfo.prevSvcArea}"/></span></td>
    <th scope="row">Next HS Area</th>
    <td><span><c:out value="${basicinfo.nextSvcArea}"/></span></td>
     <th scope="row">Distance</th>
    <td><span><c:out value="${basicinfo.distance}"/></span></td>
</tr> --%>

</tbody>
</table><!-- table end -->

<aside class="title_line"><!-- title_line start -->
<h2>Care Service Information</h2>
</aside><!-- title_line end -->
<!------------------------------------------------------------------------------
    Order Detail Page Include START
------------------------------------------------------------------------------->
<%@ include file="/WEB-INF/jsp/homecare/sales/htOrderDetailContent.jsp" %>
<!------------------------------------------------------------------------------
    Order Detail Page Include END
------------------------------------------------------------------------------->

<article class="acodi_wrap"><!-- acodi_wrap start -->
<dl>
    <dt class="click_add_on"><a href="#" onclick="javascript: fn_resizefunc(this, myDetailGridID2)">Current & History CS Result</a></dt>
    <dd>
        <article class="grid_wrap"><!-- grid_wrap start -->
             <div id="hsResult_grid_wrap" style="width:100%; height:210px; margin:0 auto;"></div>
        </article><!-- grid_wrap end -->
    </dd>
    <!-- <dt class="click_add_on"><a href="#" onclick="javascript: fn_resizefunc(this, myDetailGridID3)">Filter Transaction</a></dt>
    <dd>
        <article class="grid_wrap">grid_wrap start
         <div id="fiter_grid_wrap" style="width: 100%; height: 210px; margin: 0 auto;"></div>
        </article>grid_wrap end
    </dd> -->
</dl>
</article><!-- acodi_wrap end -->

<form action="#" id="editHSResultForm" method="post">

<aside class="title_line mt20"><!-- title_line start -->
<h2>CS Result Information</h2>
</aside><!-- title_line end -->
<table class="type1"><!-- table start -->
<caption>table</caption>
<colgroup>
    <col style="width:180px" />
    <col style="width:350px;" />
    <col style="width:170px" />
    <col style="width:*" />
</colgroup>
<tbody>
<tr>
    <th scope="row">CS Status<span class="must">*</span></th>
    <td>
    <select class="w100p"  id ="cmbStatusType2" name = "cmbStatusType2"></select>
    </td>
    <th scope="row" style="width: 186px; ">Settle Date</th>
    <td>
        <%-- <span><c:out value="${basicinfo.setlDt}"/></span> --%>
        <input type="text" title="Settle Date" placeholder="DD/MM/YYYY" class="j_date w100p" id="settleDt" name="settleDt" value="${basicinfo.setlDt}" readonly="true"/>
    </td>
</tr>
<tr>
    <th scope="row">Fail Reason</th>
    <td>
    <select class="w100p" id ="failReason"  name ="failReason">
        <option>Choose One</option>
       <c:forEach var="list" items="${failReasonList}" varStatus="status">
             <option value="${list.codeId}">${list.codeName } </option>
        </c:forEach>
    </select>
    </td>
   <!--  <th scope="row" style="width: 244px; ">Collection Code<span class="must">*</span></th> -->
    <td>
   <%--  <select class="w100p"  id ="cmbCollectType" name = "cmbCollectType">
        <option value="0" selected>Choose One</option>
            <c:forEach var="list" items="${cmbCollectTypeComboList}" varStatus="status">
                 <option value="${list.code}">${list.c1 } </option>
            </c:forEach>
    </select> --%>
    </td>
</tr>

<tr>
    <th scope="row" style="width: 176px; ">Remark</th>
    <td>
        <input id="txtRemark" name="txtRemark"  type="text" title="" placeholder="Remark" class="w100p" value="${basicinfo.resultRem}"/>
        <%-- <span>${basicinfo.resultRem}</span> --%>
    </td>
    <th scope="row" style="width: 59px; ">Instruction</th>
    <td>
        <input id="txtInstruction" name="txtInstruction"  type="text" title="" placeholder="Instruction" class="w100p" value="${basicinfo.instct}"/>
        <%-- <span>${settleInfo.configBsRem}</span> --%>
    </td>
</tr>
<tr>
    <th scope="row">Prefer Service Week</th>
    <td colspan="1">
    <label><input type="radio" name="srvBsWeek" <c:if test="${basicinfo.srvBsWeek == 0 || orderDetail.orderCfgInfo.configBsWeek > 4}">checked</c:if> disabled/><span>None</span></label>
    <label><input type="radio" name="srvBsWeek" <c:if test="${basicinfo.srvBsWeek == 1}">checked</c:if> /><span>Week1</span></label>
    <label><input type="radio" name="srvBsWeek" <c:if test="${basicinfo.srvBsWeek == 2}">checked</c:if> /><span>Week2</span></label>
    <label><input type="radio" name="srvBsWeek" <c:if test="${basicinfo.srvBsWeek == 3}">checked</c:if> /><span>Week3</span></label>
    <label><input type="radio" name="srvBsWeek" <c:if test="${basicinfo.srvBsWeek == 4}">checked</c:if> /><span>Week4</span></label>

 <%--    <label><input type="radio" name="srvBsWeek" <c:if test="${basicinfo.srvBsWeek == 4}">checked</c:if> disabled/><span>Week4</span></label> --%>
    </td>
    <%--    <th scope="row" style="width: 186px; ">Cancel Request Number</th>
     <td>
        <input id="txtCancelRN" name="txtCancelRN"  type="text" title="" placeholder="N/A" class="w100p" value="${basicinfo.cancReqNo}"  readonly />
        <span><c:out value="${basicinfo.cancReqNo}"/></span>
    </td> --%>
</tr>
</tbody>
</table><!-- table end -->

<ul class="center_btns">

</ul>

 <div  style="display:none">

 <input type="text" value="${basicinfo.schdulId}" id="hidschdulId" name="hidschdulId"/>
 <input type="text" value="${basicinfo.salesOrdId}" id="hidSalesOrdId" name="hidSalesOrdId"/>
 <input type="text" value="${basicinfo.no}" id="hidHsno" name="hidHsno"/>
 <input type="text" value="${basicinfo.c2}" id="hrResultId" name="hrResultId"/>
 <input type="text" value="${basicinfo.srvBsWeek}" id="srvBsWeek" name="srvBsWeek"/>
 <input type="text" value="${basicinfo.codyId}" id="cmbServiceMem" name="cmbServiceMem"/>

 <input type="text" value="<c:out value="${basicinfo.stusCodeId}"/> "  id="stusCode" name="stusCode"/>
 <input type="text" value="<c:out value="${basicinfo.failResnId}"/> "  id="failResn" name="failResn"/>
 <input type="text" value="<c:out value="${basicinfo.renColctId}"/> "  id="renColct" name="renColct"/>
 <input type="text" value="<c:out value="${basicinfo.codyId}"/> "  id="codyId" name="codyId"/>
 <input type="text" value="<c:out value="${basicinfo.setlDt}"/> "  id="setlDt" name="setlDt"/>
 <input type="text" value="<c:out value="${basicinfo.configBsRem}"/> "  id="configBsRem" name="configBsRem"/>
 <input type="text" value="<c:out value="${basicinfo.instct}"/> "  id="Instruction" name="Instruction"/>
 <input type="text" value=""  id="cmbCollectType1" name="cmbCollectType1"/>

 </div>
</form>
</form>
</section><!-- pop_body end -->
</div><!-- popup_wrap end -->
