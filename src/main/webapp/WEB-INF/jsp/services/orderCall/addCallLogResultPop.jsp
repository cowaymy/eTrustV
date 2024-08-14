<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>

<!--
 DATE        BY     VERSION        REMARK
 ----------------------------------------------------------------
 08/02/2019  ONGHC  1.0.0          RE-STRUCTURE JSP.
 03/04/2019  ONGHC  1.0.1          ADD CREATE & UPDATE DATETIME
 21/08/2019  ONGHC  1.0.2          Amend RDC Stock Checking
 27/11/2019  ONGHC  1.0.3          Amend Recall and Request Date Not to Choose Back Date
 -->

<script type="text/javaScript">
  function fn_saveValidation() {
    var msg = "";
    if ($("#callStatus").val() == '') {
      msg += "* <spring:message code='sys.msg.necessary' arguments='Call Log Status' htmlEscape='false'/> </br>";
    }

    if ($("#callStatus").val() == 20) {
      var rdcStk = $("#rdc").text();
      if (rdcStk.trim() != '' || rdcStk != null) {
        rdcStk = Number(rdcStk);
      } else {
        rdcStk = Number(0);
      }

      // Added for Special Delivery CT enhancement 2 by Hui Ding, 2020-04-17
      var superCtInd = $("#superCtInd").val();
      var superCtCode = $("#superCtCode").val();
      var seletedCtCode = $("#CTCode").val();

      console.log("superCtInd: " + superCtInd);
      console.log("superCtCode: " + superCtCode);

      if (typeof superCtInd === 'undefined' || superCtInd == null){
          if (rdcStk <= 0) {
        	  var leadTm = $("#leadTm").text();
              if (leadTm.trim() != '' || leadTm != null) {
            	  leadTm = Number(leadTm);
              } else {
            	  leadTm = Number(7);
              }

        	  var availDate     = new Date();
        	  var availDay      = (((availDate.getDate()+leadTm).toString().length) == 1) ? '0'+(availDate.getDate()) : (availDate.getDate());
        	  var availMonth    = (((availDate.getMonth()+1).toString().length) == 1) ? '0'+(availDate.getMonth()+1) : (availDate.getMonth()+1);
        	  var availYear     = availDate.getFullYear();
        	  var formatDate  = availDay + "/" + availMonth + "/" + availYear;

        	  var availFormattedDate  = new Date(availMonth + "/" + availDay + "/" + availYear);
              var parts = $("#requestDate").val().split("/");
              var requestFormattedDate = new Date(parts[2], parts[1] - 1, parts[0]);
              if(requestFormattedDate < availFormattedDate){
              // Common.alert("There is no available inventory in RDC to create installation order ");
              //msg += "* There is no available inventory in RDC to create installation order </br>";
              //if($("#requestDate").val() < formatDate){
            	  msg += "* There is no available inventory in RDC to create installation order. Available Installtion Date start from " + formatDate + " </br>";
              }
          }
    	  console.log("RDC empty stock ");
      } else {
          var rdcSuperCtStk = $("#rdcSuperCt").text();
          if (rdcSuperCtStk.trim() != '' || rdcSuperCtStk != null) {
              rdcSuperCtStk = Number(rdcSuperCtStk);
          } else {
              rdcSuperCtStk = Number(0);
          }

          if (seletedCtCode != null && seletedCtCode == superCtCode){
              if (rdcSuperCtStk <= 0) {
                  // Common.alert("There is no available inventory in RDC to create installation order ");
                  msg += "* There is no available inventory in Super CT RDC to create installation order </br>";
                }
          } else {
              if (rdcStk <= 0 && $("#hiddenATP").val() == 'Y') {
                  var leadTm = $("#leadTm").text();
                  if (leadTm.trim() != '' || leadTm != null) {
                      leadTm = Number(leadTm);
                  } else {
                      leadTm = Number(7);
                  }
                  console.log("leadTm " + leadTm);
                  var availDate     = new Date();
                  availDate.setDate(availDate.getDate() + leadTm);
                  var availDay      = ((availDate.getDate().toString().length) == 1) ? '0'+(availDate.getDate()) : (availDate.getDate());
                  var availMonth    = (((availDate.getMonth()+1).toString().length) == 1) ? '0'+(availDate.getMonth()+1) : (availDate.getMonth()+1);
                  var availYear     = availDate.getFullYear();
                  var formatDate  = availDay + "/" + availMonth + "/" + availYear;

                  var availFormattedDate  = new Date(availMonth + "/" + availDay + "/" + availYear);
                  var parts = $("#requestDate").val().split("/");
                  var requestFormattedDate = new Date(parts[2], parts[1] - 1, parts[0]);
                  //if($("#requestDate").val() < formatDate){
                	  if(requestFormattedDate < availFormattedDate){
                      msg += "* There is no available inventory in RDC to create installation order. Available Installtion Date start from " + formatDate + " </br>";
                  }
              }else if(rdcStk <= 0){
            	Common.alert("There is no available inventory in RDC to create installation order ");
                msg += "* There is no available inventory in RDC to create installation order </br>";
              }
          }
        }

      //if ($("#rdc").text() == '' || $("#rdc").text() == "0" || $("#rdc").text() == " ") {
        // Common.alert("There is no available inventory in RDC to create installation order ");
        //msg += "* There is no available inventory in RDC to create installation order </br>";
      //}

      if ($("#requestDate").val() == '') {
        msg += "* <spring:message code='sys.msg.necessary' arguments='Request Date' htmlEscape='false'/> </br>";
      }

      /* var custMobileNo = $("#custMobileNo").val().replace(/[^0-9\.]+/g, "") ;
      var chkMobileNo = custMobileNo.substring(0, 2);
      if (chkMobileNo == '60'){
    	  custMobileNo = custMobileNo.substring(1);
      }
      $("#custMobileNo").val(custMobileNo);
      if ($("#custMobileNo").val().trim() == '' && $("#chkSMS").is(":checked")) {
          msg += "* Please fill in customer mobile no </br> Kindly proceed to edit customer contact info </br>";
        } */

    } else if ($("#callStatus").val() == 19) {
      if ($("#recallDate").val() == '') {
        msg += "* <spring:message code='sys.msg.necessary' arguments='Recall Date' htmlEscape='false'/> </br>";
      }
    } else if ($("#callStatus").val() == 30) {
      if ($("#recallDate").val() == '') {
        msg += "* <spring:message code='sys.msg.necessary' arguments='Recall Date' htmlEscape='false'/> </br>";
      }
    }

    if ($("#feedBackCode").val() == '') {
      msg += "* <spring:message code='sys.msg.necessary' arguments='Feedback Code' htmlEscape='false'/> </br>";
    }

    var feedBackCode = $("#feedBackCode option:selected").val();
    var rdcStk = $("#rdc").text();
    if(rdcStk != "0")
    {
        if(feedBackCode == '2129' || feedBackCode == '3415') //FB26 - Stock In Transit ++
        {
            Common.alert("Currently Stock Available in RDC. Please Select Correct Feedback Code");
            return false;
        }
    }



    if (msg != "") {
      Common.alert(msg);
      return false;
    }

    return true;
  }

  function fn_saveConfirm() {
    if (fn_saveValidation()) {
	  if ($("#callStatus").val() == 20) {
         var rdcStk = $("#rdc").text();
         if (rdcStk.trim() != '' || rdcStk != null) {
           rdcStk = Number(rdcStk);
         } else {
           rdcStk = Number(0);
         }
      }
	  var msg = "";
	  if (rdcStk <= 0) {
          // Common.alert("There is no available inventory in RDC to create installation order ");
          //msg += "* There is no available inventory in RDC, STO will be create to increase stock qty</br>";
          msg = "<b>There is no available inventory in RDC, STO will be create to increase stock qty!!!</b></br></br>";
      }else{
    	  msg = "<b>Kindly confirm on stock quantity before saving!!!</b></br></br>";
      }

      if ($("#callStatus").val() != "") {
        msg += "<spring:message code='service.title.CallLogStatus'/><b>" + " : " + $("#callStatus option:selected").text() + "</b></br>";
      }

      if ($("#callStatus").val() == "19" || $("#callStatus").val() == "30" ) {
        if ($("#recallDate").val() != "") {
          msg += "<spring:message code='service.title.RecallDate'/><b>" + " : " + $("#recallDate").val() + "</b></br>";
        }
        if ($("#feedBackCode").val() != "") {
          msg += "<spring:message code='service.title.FeedbackCode'/><b>" + " : " + $("#feedBackCode option:selected").text() + "</b></br>";
        }
        if ($("#remark").val() != "") {
          msg += "<spring:message code='service.title.Remark'/><b>" + " : " + $("#remark").val() + "</b></br></br>";
        } else {
          msg += "</br>";
        }
      } else {
        if ($("#requestDate").val() != "") {
          msg += "<spring:message code='service.title.RequestDate'/><b>" + " : " + $("#requestDate").val() + "</b></br>";
        }
        if ($("#appDate").val() != "") {
          msg += "<spring:message code='service.title.AppointmentDate'/><b>" + " : " + $("#appDate").val() + "</b></br>";
        }
        if ($("#CTSSessionCode").val() != "") {
          msg += "<spring:message code='service.title.AppointmentSession'/><b>" + " : " + $("#CTSSessionCode").val() + "</b></br>";
        }
        if ($("#CTSSessionSegmentType").val() != "") {
            msg += "<spring:message code='service.title.Segment'/><b>" + " : " + $("#CTSSessionSegmentType").val() + "</b></br>";
          }
        if ($("#CTCode").val() != "") {
          msg += "<spring:message code='service.title.CTCode'/><b>" + " : " + $("#CTCode").val() + "</b></br>";
        }
        if ($("#feedBackCode").val() != "") {
          msg += "<spring:message code='service.title.FeedbackCode'/><b>" + " : " + $("#feedBackCode option:selected").text() + "</b></br>";
        }
        if ($("#remark").val() != "") {
          msg += "<spring:message code='service.title.Remark'/><b>" + " : " + $("#remark").val() + "</b></br></br>";
        } else {
          msg += "</br>";
        }
      }

      Common.confirm(msg + "<spring:message code='sys.common.alert.save'/>", fn_addCallSave);
    }
  }

  function fn_addCallSave() {

      Common.ajax("POST", "/callCenter/addCallLogResult_2.do", $("#addCallForm").serializeJSON(), function(result) {
      //Common.ajax("POST", "/callCenter/addCallLogResult.do", $("#addCallForm").serializeJSON(), function(result) {
      fn_orderCallList();
      $("#hideContent").hide();
      $("#hideContent1").hide();
      $("#hideContent3").hide();
      $("#hideContent4").hide();
      $("#hiddenBtn").hide();
      $("#sav_div").attr("style", "display:none");
      fn_callLogTransaction(); // REFRESH THE LIST

      Common.alert(result.message);
    });
  }

  function fn_success() {
  }

  function fn_callLogTransaction() {
    Common.ajax("GET", "/callCenter/getCallLogTransaction.do", $("#addCallForm").serialize(), function(result) {
      AUIGrid.setGridData(callLogTranID, result);

      /*Common.ajax("GET", "/callCenter/getVrfRmk.do", $("#addCallForm").serialize(), function(result2) {
        if (result2 != "") {
          $('#veriremark').val(result2[0].callRem);
        }
      });*/
    });
  }

  $(document).ready(
    function() {
      callLogTranGrid();
      fn_callLogTransaction();
      fn_start();

      // j_date
      var dateToday = new Date();
      var pickerOpts = { changeMonth:true,
                         changeYear:true,
                         dateFormat: "dd/mm/yy",
                           minDate: dateToday
                       };

      $(".j_date").datepicker(pickerOpts);

      var monthOptions = { pattern: 'mm/yyyy',
                           selectedYear: 2017,
                           startYear: 2007,
                           finalYear: 2027
                         };

      $(".j_date2").monthpicker(monthOptions);

      $("#stock").change(function() {
      if ($("#stock").val() == 'B') {
        Common.ajax("POST", "/callCenter/changeStock.do", $("#addCallForm").serializeJSON(),
        function(result) {
          Common.alert(result.message);
          if (result.rdcincdc != null) {
            $("#rdc").text(result.rdcincdc.raqty);
            $("#rdcInCdc").text(result.rdcincdc.rinqty);
            $("#cdc").text("0");

            if(result.rdcincdc.raqty < 1 || result.rdcincdc.raqty == '' || result.rdcincdc.raqty == null ){
            	$("#hiddenATP").val("Y");
            }else{
            	$("#hiddenATP").val("N");
            }
          } else {
            $("#rdc").text("0");
            $("#rdcInCdc").text("0");
            $("#cdc").text("0");
          }
        });
      } else {
        Common.ajax("POST", "/callCenter/changeStock.do", $("#addCallForm").serializeJSON(),
        function(result) {
          if (result.rdcincdc != null) {
            $("#rdc").text(result.rdcincdc.raqty);
            $("#rdcInCdc").text(result.rdcincdc.rinqty);
            $("#cdc").text(result.rdcincdc.caqty);
          } else {
            $("#rdc").text("0");
            $("#rdcInCdc").text("0");
            $("#cdc").text("0");
          }
        });
      }
    });

    $("#callStatus").change(function() {
      if ($("#callStatus").val() == "20") { // READY TO INSTALL
        $("#m1").show();
        $("#m3").show();
        $("#m4").show();
        $("#m2").hide();
      } else if ($("#callStatus").val() == "19") { // RECALL
        $("#m1").show();
        $("#m2").show();
        $("#m4").show();
        $("#m3").hide();
      } else if ($("#callStatus").val() == "30") { // WAITING TO CANCEL
        $("#m1").show();
        $("#m4").show();
        $("#m2").show();
        $("#m3").hide();
      }

      $("#recallDate").val("");
      $("#requestDate").val("");
      $("#appDate").val("");
      $("#CTgroup").val("");
      $("#CTSSessionCode").val("");
      $("#CTSSessionSegmentType").val("");
      $("#feedBackCode").val("");
      $("#CTCode").val("");
      $("#CTID").val("");
      $("#CTName").val("");
      $("#remark").val("");
      $("#stock").val("A");
    });
  });

  function fn_start() {
    $("#m2").hide();
    $("#m3").hide();
    $("#m4").hide();

    if ($("#callStatus").val() == "20") { // READY TO INSTALL
      $("#m1").show();
      $("#m3").show();
      $("#m4").show();
      $("#m2").hide();
    } else if ($("#callStatus").val() == "19") { // RECALL
      $("#m1").show();
      $("#m2").show();
      $("#m4").show();
      $("#m3").hide();
    } else if ($("#callStatus").val() == "30") { // WAITING TO CANCEL
      $("#m1").show();
      $("#m4").show();
      $("#m2").hide();
      $("#m3").hide();
    }

    $("#hideContent3").hide();
  }

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
    } ];

    var gridPros = {
      usePaging : true,
      pageRowCount : 20,
      editable : false,
      showStateColumn : true,
      displayTreeOpen : true,
      headerHeight : 30,
      skipReadonlyColumns : true,
      wrapSelectionMove : true,
      showRowNumColumn : true
    };

    //myGridID = GridCommon.createAUIGrid("grid_wrap", columnLayout, gridPros);
    callLogTranID = AUIGrid.create("#grid_wrap_callLogList", columnLayout, gridPros);
  }

  function fn_doAllaction() {
    var ord_id = $("#salesOrdId").val();
    var vdte = $("#requestDate").val();
    var rdcStock = $("#rdcStock").text();

    if (vdte == '') {
      return;
    }

    if (rdcStock != '0') {
      Common.popupDiv("/organization/allocation/allocation.do", {ORD_ID : ord_id, S_DATE : vdte, TYPE : 'INS'}, null, true, '_doAllactionDiv');
    } else {
      Common.alert("<spring:message code='service.msg.stock'/> ");
    }
  }

</script>
<input type="hidden" id="superCtInd" value="${superCtInd}"/>
<input type="hidden" id="superCtCode" value="${superCtCode}"/>
<div id="popup_wrap" class="popup_wrap">
 <!-- popup_wrap start -->
 <header class="pop_header">
  <!-- pop_header start -->
  <h1>
   <spring:message code='service.title.NewCallLogResult' />
  </h1>
  <ul class="right_opt">
   <li><p class="btn_blue2">
     <a href="#"><spring:message code='sys.btn.close' /></a>
    </p></li>
  </ul>
 </header>
 <!-- pop_header end -->
 <section class="pop_body">
  <!-- pop_body start -->
  <article class="acodi_wrap">
   <!-- acodi_wrap start -->
   <dl>
    <dt class="click_add_on on">
     <a href="#"><spring:message
       code='service.title.CallLogInformationTransaction' /></a>
    </dt>
    <dd>
     <table class="type1">
      <!-- table start -->
      <caption>table</caption>
      <colgroup>
       <col style="width: 140px" />
       <col style="width: *" />
       <col style="width: 135px" />
       <col style="width: *" />
      </colgroup>
      <tbody>
       <tr>
        <th scope="row"><spring:message
          code='service.title.CallLogType' /></th>
        <td><span><c:out value="${orderCall.callTypeName}" />
        </span></td>
        <th scope="row"><spring:message
          code='service.title.CreateDate' /></th>
        <td><span><c:out value="${orderCall.crtDt}" /> </span></td>
        <th scope="row"><spring:message
          code='service.title.CreateTime' /></th>
        <td>
        <span><c:out value="${orderCall.crtTm}"/> </span>
        </td>
       </tr>
        <tr>
        <th scope="row"></th>
        <td><span></span></td>
        <th scope="row"><spring:message
          code='service.title.UpdateDate' /></th>
        <td><span><c:out value="${firstCallLog[0].callDt}" /> </span></td>
        <th scope="row"><spring:message
          code='service.title.UpdateTime' /></th>
        <td>
        <span><c:out value="${firstCallLog[0].callTm}"/> </span>
        </td>
       </tr>
       <tr>
        <th scope="row"><spring:message
          code='service.title.WaitForCancel' /></th>
        <c:if test="${orderCall.isWaitCancl == '0' }">
         <td><span>No</span></td>
        </c:if>
        <c:if test="${orderCall.isWaitCancl == '1' }">
         <td><span>Yes</span></td>
        </c:if>
        <th scope="row"><spring:message
          code='service.title.Creator' /></th>
        <td><span><c:out value="${orderCall.crtUserId}" /></span></td>
        <th scope="row"></th>
        <td><span> </span></td>
       </tr>
       <tr>
        <th scope="row"><spring:message
          code='service.title.ProductToInstall' /></th>
        <td><span><c:out value="${orderCall.productCode}" />
          - <c:out value="${orderCall.productName}" /></span></td>
        <th scope="row"><spring:message
          code='service.title.CallLogStatus' /></th>
        <td><span><c:out value="${orderCall.callStusCode}" /></span>
        </td>
        <th scope="row"></th>
        <td></td>
       </tr>
       <tr>
        <th scope="row"><spring:message
          code='service.title.RDCAvailableQty' /></th>
        <td><span id="rdc"><c:out
           value="${orderRdcInCdc.raqty}" /></span></td>
        <th scope="row"><spring:message
          code='service.title.InTransitQty' /></th>
        <td><span id="rdcInCdc"><c:out
           value="${orderRdcInCdc.rinqty}" /></span></td>
        <th scope="row"><spring:message
          code='service.title.CDCAvailableQty' /></th>
        <td><c:if test="${orderRdcInCdc.rdc== orderRdcInCdc.cdc }">
          <span id="cdc">0</span>
         </c:if> <c:if test="${orderRdcInCdc.rdc != orderRdcInCdc.cdc }">
          <span id="cdc"><c:out value="${orderRdcInCdc.caqty}" /></span>
         </c:if> </td> <!--
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
        -->
       </tr>
       <tr>
        <th scope="row">Lead Time (Day)</th>
        <td><span id="leadTm"><c:out value="${orderCall.leadTm}" /></span></td>
        <th scope="row"></th>
        <td></td>
        <th scope="row"></th>
        <td></td>
       </tr>
       <!-- Added for Special Delivery CT enhancement 2 by Hui Ding, 2020-04-17 -->
       <c:if test="${superCtInd != null}">
            <tr>
                <th scope="row">Super CT RDC Qty</th>
                <td><span id="rdcSuperCt"><c:out
                   value="${rdcincdcSuperCt.raqty}" /></span></td>
                <th scope="row">Super CT In-Transit Qty</th>
                <td><span id="rdcInCdcSuperCt"><c:out
                   value="${rdcincdcSuperCt.rinqty}" /></span></td>
                <th scope="row">Super CT CDC Qty</th>
                <td>
                  <c:if test="${rdcincdcSuperCt.rdc== rdcincdcSuperCt.cdc }">
                  <span id="cdcSuperCt">0</span>
                 </c:if> <c:if test="${rdcincdcSuperCt.rdc != rdcincdcSuperCt.cdc }">
                  <span id="cdcSuperCt"><c:out value="${rdcincdcSuperCt.caqty}" /></span>
                 </c:if>
                </td>
            </tr>
       </c:if>
      </tbody>
     </table>
     <!-- table end -->
     <article class="grid_wrap mt20">
      <!-- grid_wrap start -->
      <div id="grid_wrap_callLogList"
       style="width: 100%; height: 250px; margin: 0 auto;"></div>
     </article>
     <!-- grid_wrap end -->
    </dd>
    <dt class="click_add_on">
     <a href="#"><spring:message
       code='service.title.OrderFullDetails' /></a>
    </dt>
    <dd>
     <!------------------------------------------------------------------------------
      Order Detail Page Include START
      ------------------------------------------------------------------------------->
     <%@ include file="/WEB-INF/jsp/sales/order/orderDetailContent.jsp"%>
     <!------------------------------------------------------------------------------
      Order Detail Page Include END
      ------------------------------------------------------------------------------->
    </dd>
   </dl>
  </article>
  <!-- acodi_wrap end -->
  <aside class="title_line mt20" id="hideContent3">
   <!-- title_line start -->
   <h2>
    <spring:message code='service.title.DSCVerificationRemark' />
   </h2>

  <!-- title_line end -->
  <table class="type1" id="hideContent">
   <!-- table start -->
   <caption>table</caption>
   <colgroup>
    <col style="width: 130px" />
    <col style="width: *" />
   </colgroup>
   <tbody>
    <tr>
     <th scope="row"><spring:message
       code='service.title.VerificationRemark' /></th>
     <td><textarea cols="20" rows="5"
       id="veriremark" name="veriremark" placeholder="<spring:message code='service.title.VerificationRemark' />"></textarea></td>
    </tr>
   </tbody>
  </table>
  </aside>
  <!-- table end -->
  <aside class="title_line mt20" id="hideContent4">
   <!-- title_line start -->
   <h2>
    <spring:message code='service.title.NewCallLogResult' />
   </h2>
  </aside>
  <!-- title_line end -->
  <form action="#" id="addCallForm">
   <input type="hidden" value="${orderCall.c4}" id="hiddenProductId" name="hiddenProductId" />
   <input type="hidden" value="${orderCall.callStusId}" id="hiddenCallLogStatusId" name="hiddenCallLogStatusId" />
   <input type="hidden" value="${callStusCode}" id="callStusCode" name="callStusCode" />
   <input type="hidden" value="${callStusId}" id="callStusId" name="callStusId" />
   <input type="hidden" value="${salesOrdId}" id="salesOrdId" name="salesOrdId" />
   <input type="hidden" value="${callEntryId}" id="callEntryId" name="callEntryId" />
   <input type="hidden" value="${salesOrdNo}" id="salesOrdNo" name="salesOrdNo" />
   <input type="hidden" value="${orderCall.rcdTms}" id="rcdTms" name="rcdTms" />
   <input type="hidden" value="${orderCall.callTypeId}" id="callTypeId" name="callTypeId" />
   <input type="hidden" value="${orderDetail.basicInfo.custType}" id="custType" name="custType" />
   <input type="hidden" id="raqty" value="${orderRdcInCdc.raqty}"/>
   <%-- <input type="hidden" value="${orderCall.dscBrnchId}" id="dscBrnchId" name="dscBrnchId" /> --%>
   <c:choose>
		<c:when test="${orderRdcInCdc.raqty < 1 || orderRdcInCdc.raqty == '' || orderRdcInCdc.raqty == null }">
		  <input type="hidden" value="Y" id="hiddenATP" name="hiddenATP" />
		</c:when>
		<c:otherwise>
		  <input type="hidden" value="N" id="hiddenATP" name="hiddenATP" />
		</c:otherwise>
	</c:choose>
    <%-- <c:if test="${orderRdcInCdc.raqty < 1}">
	   <input type="hidden" value="Y" id="hiddenATP" name="hiddenATP" />
	</c:if>
	<c:if test="${orderRdcInCdc.raqty >= 1}">
	   <input type="hidden" value="N" id="hiddenATP" name="hiddenATP" />
	</c:if> --%>

   <table class="type1" id="hideContent1">
    <!-- table start -->
    <caption>table</caption>
    <colgroup>
     <col style="width: 130px" />
     <col style="width: *" />
     <col style="width: 130px" />
     <col style="width: *" />
     <col style="width: 130px" />
     <col style="width: *" />
     <col style="width: 130px" />
     <col style="width: *" />
    </colgroup>
    <tbody>
     <tr>
      <th scope="row"><spring:message
        code='service.title.CallLogStatus' /><span name="m1" id="m1" class="must">*</span></th>
      <td><select class="w100p" id="callStatus" name="callStatus">
        <c:forEach var="list" items="${callLogSta}" varStatus="status">
         <c:choose>
          <c:when test="${list.code=='19' || list.code=='20' || list.code=='30'}">
           <c:choose>
            <c:when test="${list.code=='20'}">
              <option value="${list.code}" selected>${list.codeName}</option>
            </c:when>
            <c:otherwise>
              <option value="${list.code}">${list.codeName}</option>
            </c:otherwise>
           </c:choose>
          </c:when>
         </c:choose>
        </c:forEach>
      </select></td>
      <th scope="row"><spring:message
        code='service.title.RecallDate' /><span name="m2" id="m2" class="must">*</span></th>
      <td><input type="text" title="Create start Date"
       placeholder="DD/MM/YYYY" class="j_date w100p" id="recallDate"
       name="recallDate" /></td>
      <th scope="row"><spring:message
        code='service.title.RequestDate' /><span name="m3" id="m3" class="must">*</span></th>
      <td><input type="text" title="Request Date"
       placeholder="DD/MM/YYYY" class="j_date w100p" id="requestDate"
       name="requestDate" onchange="javascript:fn_doAllaction()" /></td>
      <th scope="row"><spring:message
        code='service.title.AppointmentDate' /></th>
      <td><input type="text" title="Create start Date"
       placeholder="DD/MM/YYYY" readonly="readonly"
       class="readonly j_date w100p" id="appDate" name="appDate" /></td>
     </tr>
     <tr>
      <th scope="row"><spring:message code='service.title.CTGroup' /></th>
      <td><input type="text" title="" placeholder="<spring:message code='service.title.CTGroup' />"
       class="readonly w100p" readonly="readonly" id="CTgroup"
       name="CTgroup" /> <!--  <select class="w100p" id="CTgroup"  name="CTgroup" >
        <option value="A">A</option>
        <option value="B">B</option>
        <option value="C">C</option>CT Code
    </select> --></td>
      <th scope="row"><spring:message
        code='service.title.AppointmentSessione' /></th>
      <td><input type="text" title="" placeholder="<spring:message code='service.title.AppointmentSessione' />"
       readonly="readonly" id="CTSSessionCode" name="CTSSessionCode"
       class="readonly w100p" /></td>
      <th scope="row"><spring:message code='service.title.Segment' /></th>
       <td><input type="text" title="" placeholder="<spring:message code='service.title.Segment' />"
       readonly="readonly" id="CTSSessionSegmentType" name="CTSSessionSegmentType" class="readonly w100p" /></td>
      <th scope="row"><spring:message
        code='service.title.FeedbackCode' /><span name="m4" id="m4" class="must">*</span></th>
      <td><select class="w100p" id="feedBackCode"
       name="feedBackCode">
        <option value=""><spring:message code='service.title.FeedbackCode' /></option>
        <c:forEach var="list" items="${callStatus}" varStatus="status">
            <c:choose>
                <c:when test="${list.resnId=='225'}">
                  <option value="${list.resnId}" selected>${list.c1}</option>
                </c:when>
                <c:otherwise>
                  <option value="${list.resnId}">${list.c1}</option>
                </c:otherwise>
            </c:choose>
        </c:forEach>
      </select></td>
     </tr>
     <tr>
      <th scope="row"><spring:message code='service.title.CTCode' /></th>
      <td>
       <div class="search_100p">
        <!-- search_100p start -->
        <input type="text" title="" placeholder="<spring:message code='service.title.CTCode' />"
         class="readonly w100p" readonly="readonly" id="CTCode"
         name="CTCode" /> <input type="hidden" placeholder=""
         class="w100p" id="CTID" name="CTID" />
        <%-- <a href="#" class="search_btn" onclick="javascript:fn_doAllaction()"><img src="${pageContext.request.contextPath}/resources/images/common/normal_search.gif" alt="search" /></a> --%>
       </div>
       <!-- search_100p end -->
      </td>
      <th scope="row"><spring:message code='service.title.CTName' /></th>
      <td colspan="3"><input type="text" title="" placeholder="<spring:message code='service.title.CTName' />"
       class="readonly w100p" readonly="readonly" id="CTName"
       name="CTName" /></td>
      <th scope="row">Grade A - B</th>
      <td colspan="1"><select class="w100p" id="stock" name="stock">
        <option value="A">A</option>
        <option value="B">B</option>
      </select></td>
     </tr>
      <%-- <tr>
     <th scope="row">Mobile<span name="m2" id="m2" class="must">*</span></th>
      <td colspan="3">
          <input type="text" title="" value ="${orderDetail.installationInfo.instCntTelM}" placeholder="Mobile No" id="custMobileNo" name="custMobileNo" />
          <span>SMS</span><input type="checkbox" id="chkSMS" name="chkSMS" checked>
          <br><br>
          <span>Total SMS Count :</span><input type="text" id="smsCount" name="smsCount" class="readonly" readonly="readonly" style="width:10%;">
     </td> 
     <th></th><td colspan="3"></td>
     </tr> --%>
     <tr>
      <th scope="row"><spring:message code='service.title.Remark' /></th>
      <td colspan="7"><textarea cols="20" rows="5" placeholder="<spring:message code='service.title.Remark' />"
        id="remark" name="remark"></textarea></td>
     </tr>
    </tbody>
   </table>
   <!-- table end -->
  </form>
  <div id='sav_div'>
   <ul class="center_btns" id="hiddenBtn">
    <li><p class="btn_blue2 big">
      <a href="#" onclick="fn_saveConfirm()">Save</a>
     </p></li>
    <li><p class="btn_blue2 big">
      <a href="#">Clear</a>
     </p></li>
   </ul>
  </div>
 </section>
 <!-- pop_body end -->
</div>
<!-- popup_wrap end -->
