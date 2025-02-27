<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>

<!--
 DATE        BY     VERSION        REMARK
 ----------------------------------------------------------------
 25/02/2019  ONGHC  1.0.0          RE-STRUCTURE JSP.
 27/02/2019  ONGHC  1.0.1          Amend error message while search
 05/03/2019  ONGHC  1.0.2          Remove selection mode as singleRow
 02/04/2019  ONGHC  1.0.3          Add Post Code Column
 02/04/2019  ONGHC  1.0.4          Add DSC Code Column
 -->

<script type="text/javaScript">
  var callStusCode;
  var callStusId;
  var salesOrdId;
  var callEntryId;
  var salesOrdNo;
  var rcdTms;
  var waStusCodeId;
  var waStusDesc;
  var callCrtDt;

  // Empty Set
  var emptyData = [];
  var myGridID;

  //Start AUIGrid
  $(document)
      .ready(
          function() {
            // SET COMBO DATA
            // APPLICATION CODE
            doGetComboOrder('/common/selectCodeList.do', '10', 'CODE_ID', '', 'listAppType', 'M', 'fn_multiCombo'); //Common Code
            // DSC CODE
            doGetComboSepa('/common/selectBranchCodeList.do', '5', ' - ', '', 'listDSCCode', 'M', 'fn_multiCombo'); //Branch Code
            // STATE CODE
            doGetCombo('/callCenter/getstateList.do', '', '', 'ordStatus', 'S', '');
            // AREA CODE
            doDefCombo(emptyData, '', 'ordArea', 'S', '');
            //PRODUCT
            doGetComboOrder('/callCenter/selectProductList.do', '', 'CODE_ID', '', 'callLogProductList', 'M', 'fn_multiCombo'); //Common Code
            // PROMOTION
            doGetComboOrder('/callCenter/selectPromotionList.do', '', 'CODE_ID', '', 'callLogPromotionList', 'M', 'fn_multiCombo'); //Common Code

            $("#ordStatus").change(
              function() {
                $("#ordArea").find('option').each(
                  function() {
                    $(this).remove();
                  });

                  if ($(this).val().trim() == "") {
                   doDefCombo(emptyData, '', 'ordArea', 'S', '');
                   return;
                  }

                  doGetCombo('/callCenter/getAreaList.do', $(this).val(), '', 'ordArea', 'S', '');
              });

            // AUIGrid 그리드를 생성합니다.
            orderCallListGrid();
            //AUIGrid.setSelectionMode(myGridID, "singleRow");

            AUIGrid
                .bind(
                    myGridID,
                    "cellDoubleClick",
                    function(event) {
                      callStusCode = AUIGrid
                          .getCellValue(myGridID,
                              event.rowIndex,
                              "callStusCode");

                      callStusId = AUIGrid.getCellValue(
                          myGridID, event.rowIndex,
                          "callStusId");

                      salesOrdId = AUIGrid.getCellValue(
                          myGridID, event.rowIndex,
                          "salesOrdId");

                      callEntryId = AUIGrid.getCellValue(
                          myGridID, event.rowIndex,
                          "callEntryId");

                      salesOrdNo = AUIGrid.getCellValue(
                          myGridID, event.rowIndex,
                          "salesOrdNo");

                      waStusCodeId = AUIGrid.getCellValue(
                          myGridID, event.rowIndex,
                          "waStusCodeId");

                      waStusDesc = AUIGrid.getCellValue(
                          myGridID, event.rowIndex,
                          "waStusDesc");

                      callCrtDt = AUIGrid.getCellValue(
                              myGridID, event.rowIndex,
                              "crtDt");

                      Common
                          .popupDiv("/callCenter/viewCallResultPop.do?isPop=true&callStusCode=" + callStusCode
                              + "&callStusId=" + callStusId
                              + "&salesOrdId=" + salesOrdId
                              + "&callEntryId=" + callEntryId
                              + "&salesOrdNo=" + salesOrdNo
                              + "&salesOrderId=" + salesOrdId);
                    });

            AUIGrid.bind(myGridID, "cellClick", function(event) {
              callStusCode = AUIGrid.getCellValue(myGridID, event.rowIndex, "callStusCode");
              callStusId = AUIGrid.getCellValue(myGridID, event.rowIndex, "callStusId");
              salesOrdId = AUIGrid.getCellValue(myGridID, event.rowIndex, "salesOrdId");
              callEntryId = AUIGrid.getCellValue(myGridID, event.rowIndex, "callEntryId");
              salesOrdNo = AUIGrid.getCellValue(myGridID, event.rowIndex, "salesOrdNo");
              rcdTms = AUIGrid.getCellValue(myGridID, event.rowIndex, "rcdTms");
              waStusCodeId = AUIGrid.getCellValue(myGridID, event.rowIndex, "waStusCodeId");
              waStusDesc = AUIGrid.getCellValue(myGridID, event.rowIndex, "waStusDesc");
              callCrtDt = AUIGrid.getCellValue(myGridID, event.rowIndex, "crtDt");
              //Common.popupDiv("/organization/requestTerminateResign.do?isPop=true&MemberID=" + AUIGrid.getCellValue(myGridID, event.rowIndex, "memberid")+"&MemberType=" + AUIGrid.getCellValue(myGridID, event.rowIndex, "membertype"), "");
            });
          });

  function fn_multiCombo() {
    $('#listAppType').change(function() {
    }).multipleSelect({
      selectAll : true, // 전체선택
      width : '100%'
    });

    $('#callLogProductList').change(function() {
    }).multipleSelect({
      selectAll : true, // 전체선택
      width : '100%'
    });

    $('#callLogPromotionList').change(function() {
    }).multipleSelect({
      selectAll : true, // 전체선택
      width : '100%'
    });

    $('#listDSCCode').change(function() {
    }).multipleSelect({
      selectAll : true, // 전체선택
      width : '100%'
    });

    $('#searchFeedBackCode').change(function() {
    }).multipleSelect({
      selectAll : true, // 전체선택
      width : '100%'
    });

  }

  function fn_orderCallList() {
    if ($("#orderNo").val() == "") {
      /*  if( $("#createDate").val() =="" ||  $("#endDate").val() ==""  ||   $("#listDSCCode").val() ==""  ) */
      if ($("#createDate").val() == "" || $("#endDate").val() == "") {
        Common.alert("<spring:message code='service.msg.ordNoDtReq'/>");
        return;
      }
    }

    Common.ajax("GET", "/callCenter/searchOrderCallList.do", $("#instOrderCallSearchForm").serialize(), function(result) {
      AUIGrid.setGridData(myGridID, result);
    });
  }

  function fn_openAddCall() {
	  if(waStusCodeId == 44){
          var todayDate = new Date();
          var crtDateExpiry = new Date(callCrtDt);
          crtDateExpiry.setDate(crtDateExpiry.getDate() + 1);

			if(todayDate <= crtDateExpiry) {
			      Common.alert("Pending Whatsapp Appointment Confirmation.");
		          return;
			}
	  }

    if (callStusId == "1" || callStusId == "19" || callStusId == "30") {
      Common.ajax("POST", "/callCenter/selRcdTms.do", {
          callStusCode : callStusCode,
          callStusId : callStusId,
          salesOrdId : salesOrdId,
          callEntryId : callEntryId,
          salesOrdNo : salesOrdNo,
          salesOrderId : salesOrdId,
          rcdTms : rcdTms
        }, function(result) {
        if (result.code == "99") {
          Common.alert(result.message);
          return;
        } else {
          //Common.popupDiv("/callCenter/addCallResultPop.do?isPop=true&callStusCode=" + callStusCode+"&callStusId=" + callStusId+"&salesOrdId=" + salesOrdId+"&callEntryId=" + callEntryId+"&salesOrdNo=" + salesOrdNo+"&salesOrderId=" + salesOrdId);
          Common.popupDiv("/callCenter/addCallResultPop.do", {
              callStusCode : callStusCode,
              callStusId : callStusId,
              salesOrdId : salesOrdId,
              callEntryId : callEntryId,
              salesOrdNo : salesOrdNo,
              salesOrderId : salesOrdId,
              rcdTms : rcdTms
          });
        }
      });
    } else if (callStusId == "10") {
      Common.alert("<spring:message code='service.msg.callLogCan'/> ");
    } else if (callStusId == "20") {
      Common.alert("<spring:message code='service.msg.callLogRDY'/> ");
    } else {
      Common.alert("<spring:message code='service.msg.selectRcd'/> ");
    }
  }

  function orderCallListGrid() {
    var columnLayout = [ {
      dataField : "callTypeCode",
      headerText : '<spring:message code="service.grid.Type" />',
      editable : false,
      width : 100
    }, {
      dataField : "callStusCode",
      headerText : '<spring:message code="service.grid.Status" />',
      editable : false,
      width : 100
    },{
       dataField : "waStusDesc",
       headerText : 'WA Status',
       editable : false,
       width : 100
    },{
      dataField : "waStusCode",
      headerText : "",
      width : 0
    },{
      dataField : "waStusCodeId",
      headerText : "",
      width : 0
    },{
        dataField : "c3",
        headerText : 'Order key in date',
        dataType: "date",
        formatString: "dd/mm/yyyy",
        editable : false,
        width : 120
    },{
        dataField : "callLogEntryDate",
        headerText : 'Call Log Entry Date',
        /* dataType: "date",
        formatString: "dd/mm/yyyy", */
        editable : false,
        width : 120
    },{
      dataField : "callLogDt",
      headerText : '<spring:message code="service.grid.Date" />',
      dataType: "date",
      formatString: "dd/mm/yyyy",
      editable : false,
      width : 130
    }, {
      dataField : "salesOrdNo",
      headerText : '<spring:message code="service.grid.OrderNo" />',
      editable : false,
      width : 150
    },{ // Added Feedback Code by Hui Ding. 12-04-2021
        dataField : "feedBack",
        headerText : '<spring:message code="service.title.FeedbackCode" />',
        editable : false,
        width : 150
    }, {
      dataField : "appTypeName",
      headerText : '<spring:message code="service.grid.AppType" />',
      editable : false,
      style : "my-column",
      width : 100
    }, {
      dataField : "productCode",
      headerText : '<spring:message code="service.grid.Product" />',
      editable : false,
      width : 180
    }, {
      dataField : "custName",
      headerText : '<spring:message code="service.grid.Customer" />',
      editable : false,
      width : 180
    }, {
      dataField : "state",
      headerText : '<spring:message code="service.grid.State" />',
      editable : false,
      width : 180
    }, {
        dataField : "city",
        headerText : 'City',
        editable : false,
        width : 180
      }, {
      dataField : "area",
      headerText : '<spring:message code="service.grid.Area" />',
      editable : false,
      width : 180
    }, {
      dataField : "postcode",
      headerText : '<spring:message code="service.grid.PostCode" />',
      editable : false,
      width : 180
    }, {
      dataField : "dscCode",
      headerText : '<spring:message code="service.grid.Branch" />',
      editable : false,
      width : 180
    }, {
      dataField : "isWaitCancl",
      headerText : '<spring:message code="service.grid.WaitCancel" />',
      width : 180
    }, {
      dataField : "callStusId",
      headerText : "",
      width : 0
    }, {
      dataField : "salesOrdId",
      headerText : "",
      width : 0
    }, {
      dataField : "callEntryId",
      headerText : "",
      width : 0
    }, {
      dataField : "rcdTms",
      headerText : "",
      width : 0
    },{
        dataField : "crtDt",
        headerText : "",
        width : 0
    } ];

    var gridPros = {
      usePaging : true,
      pageRowCount : 20,
      editable : true,
      showStateColumn : false,
      displayTreeOpen : true,
      headerHeight : 30,
      skipReadonlyColumns : true,
      wrapSelectionMove : true,
      showRowNumColumn : true
    };

    myGridID = AUIGrid.create("#grid_wrap_callList", columnLayout, gridPros);
  }

  var gridPros = {
    usePaging : true,
    pageRowCount : 20,
    editable : true,
    fixedColumnCount : 1,
    showStateColumn : true,
    displayTreeOpen : true,
    //selectionMode : "singleRow",
    headerHeight : 30,
    useGroupingPanel : true,
    skipReadonlyColumns : true,
    wrapSelectionMove : true,
    showRowNumColumn : false,
  };

  function fn_excelDown() {
    // type : "xlsx", "csv", "txt", "xml", "json", "pdf", "object"
    GridCommon.exportTo("grid_wrap_callList", "xlsx", "Order Call Log Search");
  }

  function fn_clear() {
    $("#orderNo").val("");
    $("#listAppType").val("");
    $("#createDate").val("");
    $("#endDate").val("");
    $("#ordStatus").val("");
    $("#ordArea").val("");
    $("#callLogProductList").val("");
    $("#callLogPromotionList").val("");
    $("#callLogType").val("");
    $("#callLogStatus").val("");
    $("#callStrDate").val("");
    $("#callEndDate").val("");
    $("#custId").val("");
    $("#custName").val("");
    $("#nricNo").val("");
    $("#contactNo").val("");
    $("#listDSCCode").val("");
    $("#PONum").val("");
    $("#searchFeedBackCode").val("");
    $("#sortBy").val("0");
  }

  function fn_callLogAppointmentBlastPop(){
      Common.popupDiv("/callCenter/callLogAppointmentManualBlastPop.do", null, null, true, '_callLogAppointmentManualBlastPop');
	}

</script>
<section id="content">
 <spring:message code="service.placeHolder.ordNo" var="ordNo"/>
 <spring:message code="service.placeHolder.dtFmt" var="dtFmt"/>
 <spring:message code="service.placeHolder.custId" var="custId"/>
 <spring:message code="service.placeHolder.custNm" var="custNm"/>
 <spring:message code="service.placeHolder.unqNo" var="unqNo"/>
 <spring:message code="service.placeHolder.contcNo" var="contcNo"/>
 <spring:message code="service.placeHolder.poNo" var="poNo"/>
 <spring:message code="service.title.strDt" var="crtDt"/>
 <spring:message code="service.title.endDt" var="endDt"/>

 <!-- content start -->
 <ul class="path">
  <li><img
   src="${pageContext.request.contextPath}/resources/images/common/path_home.gif"
   alt="Home" /></li>
  <li>Sales</li>
  <li>Order list</li>
 </ul>
 <aside class="title_line">
  <!-- title_line start -->
  <p class="fav">
   <a href="#" class="click_add_on">My menu</a>
  </p>
  <h2>
   <spring:message code='service.title.OrderCallLogSearch' />
  </h2>
  <ul class="right_btns">
   <c:if test="${PAGE_AUTH.funcUserDefine1 == 'Y'}">
    <li><p class="btn_blue">
      <a href="#" onClick="fn_openAddCall()"><spring:message
        code='service.btn.addCallLogResult' /></a>
     </p></li>
   </c:if>
   <c:if test="${PAGE_AUTH.funcView == 'Y'}">
    <li><p class="btn_blue">
      <a href="#" onClick="javascript:fn_orderCallList()"><span
       class="search"></span> <spring:message code='sys.btn.search' /></a>
     </p></li>
   </c:if>
   <li><p class="btn_blue">
     <a href="#" onClick="javascript:fn_clear()"><span class="clear"></span> <spring:message
       code='sys.btn.clear' /></a>
    </p></li>
  </ul>
 </aside>
 <!-- title_line end -->
 <section class="search_table">
  <!-- search_table start -->
  <form action="#" method="post" id="instOrderCallSearchForm">
   <table class="type1">
    <!-- table start -->
    <caption>table</caption>
    <colgroup>
     <col style="width: 150px" />
     <col style="width: *" />
     <col style="width: 150px" />
     <col style="width: *" />
     <col style="width: 150px" />
     <col style="width: *" />
    </colgroup>
    <tbody>
     <tr>
      <th scope="row"><spring:message code='service.title.OrderNo' /><span name="m1" id="m1" class="must">*</span></th>
      <td><input type="text" title="" placeholder="${ordNo}"
       class="w100p" id="orderNo" name="orderNo" /></td>
      <th scope="row"><spring:message
        code='service.title.ApplicationType' /></th>
      <td><select class="multy_select w100p" multiple="multiple"
       id="listAppType" name="appType">
      </select></td>
      <th scope="row"><spring:message
        code='service.title.OrderDate' /><span name="m1" id="m1" class="must">*</span></th>
      <td>
       <div class="date_set">
        <!-- date_set start -->
        <p>
         <input type="text" title="${crtDt}"
          placeholder="${dtFmt}" class="j_date" id="createDate"
          name="createDate" />
        </p>
        <span>To</span>
        <p>
         <input type="text" title="${endDt}"
          placeholder="${dtFmt}" class="j_date" id="endDate"
          name="endDate" />
        </p>
       </div> <!-- date_set end -->
      </td>
     </tr>
     <tr>
      <th scope="row"><spring:message code='service.title.State' /></th>
      <td><select class="w100p" id="ordStatus" name="ordStatus">
      </select></td>
      <th scope="row"><spring:message code='service.title.Area' /></th>
      <td><select class="w100p" id="ordArea" name="ordArea">
      </select></td>
      <th scope="row"><spring:message code='service.title.Product' /></th>
      <td><select class="multy_select w100p" multiple="multiple" id="callLogProductList" name="product">
       <!--  <option value="">Choose One</option> -->
       <%--  <c:forEach var="list" items="${productList}" varStatus="status">
         <option value="${list.stkId}">${list.c1}</option>
        </c:forEach> --%>
      </select></td>
     </tr>
     <tr>
      <th scope="row"><spring:message
        code='service.title.CallLogType' /></th>
      <td><select class="multy_select w100p" multiple="multiple"
       id="callLogType" name="callLogType" >
        <c:forEach var="list" items="${callLogTyp}" varStatus="status">
         <c:choose>
           <c:when test="${list.code=='257'}">
             <option value="${list.code}" selected>${list.codeName}</option>
           </c:when>
           <c:otherwise>
             <option value="${list.code}">${list.codeName}</option>
           </c:otherwise>
         </c:choose>
        </c:forEach>
      </select></td>
      <th scope="row"><spring:message
        code='service.title.CallLogStatus' /></th>
      <td><select class="multy_select w100p" multiple="multiple"
       id="callLogStatus" name="callLogStatus">

        <c:forEach var="list" items="${callLogSta}" varStatus="status">
         <c:choose>
           <c:when test="${list.code=='1' || list.code=='19'}">
             <option value="${list.code}" selected>${list.codeName}</option>
           </c:when>
           <c:otherwise>
             <option value="${list.code}">${list.codeName}</option>
           </c:otherwise>
         </c:choose>
        </c:forEach>

        <!-- <option value="1" selected>Active</option>
        <option value="10">Cancelled</option>
        <option value="19" selected>Recall</option>
        <option value="20">Ready To Install</option>
        <option value="30">Waiting For Cancel</option> -->
      </select></td>
      <th scope="row"><spring:message
        code='service.title.CallLogDate' /></th>
      <td>
       <div class="date_set">
        <!-- date_set start -->
        <p>
         <input type="text" title="${crtDt}"
          placeholder="${dtFmt}" class="j_date" id="callStrDate"
          name="callStrDate" />
        </p>
        <span>To</span>
        <p>
         <input type="text" title="${endDt}"
          placeholder="${dtFmt}" class="j_date" id="callEndDate"
          name="callEndDate" />
        </p>
       </div> <!-- date_set end -->
      </td>
     </tr>
     <tr>
      <th scope="row"><spring:message
        code='service.title.CustomerID' /></th>
      <td><input type="text" title="" placeholder="${custId}"
       class="w100p" id="custId" name="custId" /></td>
      <th scope="row"><spring:message
        code='service.title.CustomerName' /></th>
      <td><input type="text" title="" placeholder="${custNm}"
       class="w100p" id="custName" name="custName" /></td>
      <th scope="row"><spring:message
        code='service.title.NRIC_CompanyNo' /></th>
      <td><input type="text" title=""
       placeholder="${unqNo}" class="w100p" id="nricNo"
       name="nricNo" /></td>
     </tr>
     <tr>
      <th scope="row"><spring:message
        code='service.title.ContactNo' /></th>
      <td><input type="text" title="" placeholder="${contcNo}"
       class="w100p" id="contactNo" name="contactNo" /></td>
      <th scope="row"><spring:message code='service.title.DSCCode' /></th>
      <td><select class="select w100p" id="listDSCCode"
       name="DSCCode">
      </select></td>
      <th scope="row"><spring:message code='service.title.PONumber' /></th>
      <td><input type="text" title="" placeholder="${poNo}"
       class="w100p" id="PONum" name="PONum" /></td>
     </tr>
     <tr>
      <th scope="row"><spring:message code='service.title.SortBy' /></th>
      <td colspan="5"><select class="w100p" id="sortBy"
       name="sortBy">

        <c:forEach var="list" items="${callLogSrt}" varStatus="status">
         <c:choose>
           <c:when test="${list.code=='4'}">
             <option value="${list.code}" selected>${list.codeName}</option>
           </c:when>
           <c:otherwise>
             <option value="${list.code}">${list.codeName}</option>
           </c:otherwise>
         </c:choose>
        </c:forEach>

        <!-- <option value="0" selected>No Sorting</option>
        <option value="1">Order Number</option>
        <option value="2">Customer Name</option> -->
      </select></td>
     </tr>

     <tr>
      <th scope="row">Promotion Code</th>
      <td><select class="multy_select w100p" multiple="multiple" id="callLogPromotionList" name="promotion">
       <!--  <option value="">Choose One</option> -->
     <%--    <c:forEach var="list" items="${promotionList}" varStatus="status">
         <option value="${list.promoId}">${list.c1}</option>
        </c:forEach> --%>
      </select></td>
      <th scope="row">Feedback Code</th>
      <td><select class="w100p" id="searchFeedBackCode" name="searchFeedBackCode" multiple>
            <option value=""><spring:message code='service.title.FeedbackCode' /></option>
	        <c:forEach var="list" items="${callStatus}" varStatus="status">
	           <option value="${list.resnId}">${list.c1}</option>
	        </c:forEach>
	   </select></td>
	   <th scope="row">is e-Commerce</th>
    <td>
    <input id="isECommerce" name="isECommerce" type="checkbox"/>
    </td>
     </tr>

    </tbody>
   </table>
   <!-- table end -->
   <%-- <aside class="link_btns_wrap"><!-- link_btns_wrap start -->
<p class="show_btn"><a href="#"><img src="${pageContext.request.contextPath}/resources/images/common/btn_link.gif" alt="link show" /></a></p>
<dl class="link_list">
    <dt>Link</dt>
    <dd>
    <ul class="btns">
        <li><p class="link_btn"><a href="#" onClick="fn_openAddCall()">Add Call Log Result</a></p></li>
       <li><p class="link_btn"><a href="#">menu2</a></p></li>
        <li><p class="link_btn"><a href="#">menu3</a></p></li>
        <li><p class="link_btn"><a href="#">menu4</a></p></li>
        <li><p class="link_btn"><a href="#">Search Payment</a></p></li>
        <li><p class="link_btn"><a href="#">menu6</a></p></li>
        <li><p class="link_btn"><a href="#">menu7</a></p></li>
        <li><p class="link_btn"><a href="#">menu8</a></p></li>
    </ul>
    <ul class="btns">
        <li><p class="link_btn type2"><a href="#">menu1</a></p></li>
        <li><p class="link_btn type2"><a href="#">Search Payment</a></p></li>
        <li><p class="link_btn type2"><a href="#">menu3</a></p></li>
        <li><p class="link_btn type2"><a href="#">menu4</a></p></li>
        <li><p class="link_btn type2"><a href="#">Search Payment</a></p></li>
        <li><p class="link_btn type2"><a href="#">menu6</a></p></li>
        <li><p class="link_btn type2"><a href="#">menu7</a></p></li>
        <li><p class="link_btn type2"><a href="#">menu8</a></p></li>
    </ul>
    <p class="hide_btn"><a href="#"><img src="${pageContext.request.contextPath}/resources/images/common/btn_link_close.gif" alt="hide" /></a></p>
    </dd>
</dl>
</aside><!-- link_btns_wrap end --> --%>
  </form>

  <!-- title_line start -->
    <article class="link_btns_wrap">
        <p class="show_btn"><a href="#"><img src="${pageContext.request.contextPath}/resources/images/common/btn_link.gif" alt="link show" /></a></p>
        <dl class="link_list">
            <dt><spring:message code="sal.title.text.link" /></dt>
            <dd>
                <ul class="btns">
                <c:if test="${PAGE_AUTH.funcUserDefine2 == 'Y'}">
                     <li><p class="link_btn"><a href="javascript:fn_callLogAppointmentBlastPop();" id="waAppointmentBlastPop">Whatsapp Manual Blast</a></li>
                     </c:if>
                </ul>
                <p class="hide_btn"><a href="#"><img src="${pageContext.request.contextPath}/resources/images/common/btn_link_close.gif" alt="hide" /></a></p>
            </dd>
        </dl>
    </article>
  <!-- title_line end -->

 </section>
 <!-- search_table end -->
 <section class="search_result">
  <!-- search_result start -->
  <ul class="right_btns">
   <c:if test="${PAGE_AUTH.funcUserDefine1 == 'Y'}">
    <li><p class="btn_grid">
      <a href="#" onClick="fn_excelDown()"><spring:message
        code='service.btn.Generate' /></a>
     </p></li>
   </c:if>
   <!-- <l  i><p class="btn_grid"><a href="#">EXCEL UP</a></p></li>
    <li><p class="btn_grid"><a href="#">EXCEL DW</a></p></li>
    <li><p class="btn_grid"><a href="#">DEL</a></p></li>
    <li><p class="btn_grid"><a href="#">INS</a></p></li>
    <li><p class="btn_grid"><a href="#">ADD</a></p></li> -->
  </ul>
  <article class="grid_wrap">
   <!-- grid_wrap start -->
   <div id="grid_wrap_callList"
    style="width: 100%; height: 500px; margin: 0 auto;"></div>
  </article>
  <!-- grid_wrap end -->
 </section>
 <!-- search_result end -->
</section>
<!-- content end -->
