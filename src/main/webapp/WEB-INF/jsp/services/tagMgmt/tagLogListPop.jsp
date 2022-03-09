<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>
<script type="text/javaScript">
  var gridID1;
  function tagRespondGrid() {

    var columnLayout1 = [ {
      dataField : "mainDepartment",
      headerText : "<spring:message code='service.grid.mainDept'/>",
      width : '10%'
    }, {
      dataField : "subDepartment",
      headerText : "<spring:message code='service.grid.subDept'/>",
      width : '10%'
    }, {
      dataField : "remarkCont",
      headerText : "<spring:message code='service.grid.Remark'/>",
      width : '40%'
    }, {
      dataField : "regNm",
      headerText : "<spring:message code='service.grid.CreateBy'/>",
      width : '20%'
    }, {
      dataField : "statusNm",
      headerText : "<spring:message code='service.grid.Status'/>",
      width : '10%'
    }, {
      dataField : "crtDate",
      headerText : "<spring:message code='service.grid.registerDt'/>",
      dataType : "date",
      width : '10%'
    }

    ];

    var gridPros1 = {
      pageRowCount : 20,
      showStateColumn : false,
      displayTreeOpen : false,
      //selectionMode : "singleRow",
      skipReadonlyColumns : true,
      wrapSelectionMove : true,
      showRowNumColumn : true,
      editable : false,
      wordWrap : true
    };

    gridID1 = GridCommon.createAUIGrid("respond_grid_wrap", columnLayout1, "", gridPros1);

  }

  $(document).ready(
    function() {
      tagRespondGrid();
      setInputFile2();

      $(".auto_file").append("<label><span class='label_text'><a href='#'>File</a></span><input type='text' class='input_text' readonly='readonly' /></label>");

      $("#respondInfo").click(
        function() {
          var counselingNum = $("#counselingNo").text();

          Common.ajax("Get", "/services/tagMgmt/getRemarkResults.do?counselingNo=" + counselingNum + "", '',
            function(result) {
              AUIGrid.setGridData(gridID1, result);
              AUIGrid.resize(gridID1, 900, 300);
            });
          });

          doGetCombo('/services/tagMgmt/selectMainDept.do', '', '', 'inputMainDept', 'S', '');

          $("#inputMainDept").change(
            function() {
              if ($("#inputMainDept").val() == '') {
                $("#inputSubDept").val('');
                $("#inputSubDept").find("option").remove();
              } else {
                doGetCombo('/services/tagMgmt/selectSubDept.do', $("#inputMainDept").val(), '', 'inputSubDept', 'S', '');
              }
           });

          $('#btnLedger1').click(function() {
            if ("${orderDetail.basicInfo.ordId}" == "") {
              var text = "<spring:message code='service.title.OrderNo'/>";
              Common.alert("<spring:message code='sys.msg.notexist' arguments='" + text + "' htmlEscape='false'/>");
              return;
            }
            Common.popupWin("tagMngmForm", "/sales/order/orderLedgerViewPop.do", {width : "1000px", height : "720", resizable: "no", scrollbars: "no"});
          });
          $('#btnLedger2').click(function() {
            if ("${orderDetail.basicInfo.ordId}" == "") {
              var text = "<spring:message code='service.title.OrderNo'/>";
              Common.alert("<spring:message code='sys.msg.notexist' arguments='" + text + "' htmlEscape='false'/>");
              return;
            }
            Common.popupWin("tagMngmForm", "/sales/order/orderLedger2ViewPop.do", {width : "1000px", height : "720", resizable: "no", scrollbars: "no"});
          });

            /* atchFileGrpId */
            var attachList = $("#atchFileGrpId").val();
            Common.ajax("Get", "/services/tagMgmt/selectAttachList.do", { atchFileGrpId : attachList },
              function(result) {
                if (result) {
                  if (result.length > 0) {
                    $("#attachTd").html("");
                    for (var i = 0; i < result.length; i++) {
                      //$("#attachTd").append("<div class='auto_file2 auto_file3'><input type='text' class='input_text' readonly='readonly' value='" + attachList[i].atchFileName + "'/></div>");
                      var atchTdId = "atchId" + (i + 1);
                      $("#attachTd").append("<div class='auto_file2 auto_file3'><input type='text' class='input_text' readonly='readonly' name='" + atchTdId + "'/></div>");
                      $(".input_text[name='" + atchTdId + "']").val(result[i].atchFileName);
                    }

                    // 파일 다운
                    $(".input_text").dblclick(
                      function() {
                        var oriFileName = $(this).val();
                        var fileGrpId;
                        var fileId;
                        for (var i = 0; i < result.length; i++) {
                          if (result[i].atchFileName == oriFileName) {
                            fileGrpId = result[i].atchFileGrpId;
                            fileId = result[i].atchFileId;
                          }
                        }
                        fn_atchViewDown(fileGrpId, fileId);
                    });
                  }
                }
              });

            /* atchFileGrpId2 */
            //var attachList2 = ${tagMgmtDetail.counselingNo};
            Common.ajax("Get", "/services/tagMgmt/selectAttachList2.do", { atchFileGrpId : $("#counselingNo").text() },
              function(result) {
                if (result) {
                  if (result.length > 0) {
                    $("#attachTd").html("");
                    for (var i = 0; i < result.length; i++) {
                      //$("#attachTd").append("<div class='auto_file2 auto_file3'><input type='text' class='input_text' readonly='readonly' value='" + attachList[i].atchFileName + "'/></div>");
                      var atchTdId = "atchId2" + (i + 1);
                      $("#attachTd2").append("<div class='auto_file2 auto_file3'><input type='text' class='input_text' readonly='readonly' name='" + atchTdId + "'/></div>");
                      $(".input_text[name='" + atchTdId + "']").val(result[i].atchFileName);
                    }

                    // 파일 다운
                    $(".input_text").dblclick(
                      function() {
                        var oriFileName = $(this).val();
                        var fileGrpId;
                        var fileId;
                        for (var i = 0; i < result.length; i++) {
                          if (result[i].atchFileName == oriFileName) {
                            fileGrpId = result[i].atchFileGrpId;
                            fileId = result[i].atchFileId;
                          }
                        }
                        fn_atchViewDown(fileGrpId, fileId);
                    });
                  }
                }
              });
    });

  function setInputFile2(){//인풋파일 세팅하기
    $(".auto_file2").append("<label><input type='text' class='input_text' readonly='readonly' /><span class='label_text'><a href='#'><spring:message code='commission.text.search.file' /></a></span></label><span class='label_text'><a href='#'><spring:message code='sys.btn.add' /></a></span><span class='label_text'><a href='#'><spring:message code='sys.btn.delete' /></a></span>");
  }

  function fn_saveRemarkResult() {
    var msg = "";
    var text = "";
    if ($("#inputMainDept").val() == "") {
      text = "<spring:message code='service.grid.mainDept'/>"
      msg += "* <spring:message code='sys.msg.necessary' arguments='" + text + "' htmlEscape='false'/> </br>"
    }
/*     if ($("#inputSubDept").val() == "") {
      text = "<spring:message code='service.grid.subDept'/>"
      msg += "* <spring:message code='sys.msg.necessary' arguments='" + text + "' htmlEscape='false'/> </br>"
    } */
    if ($("#status").val() == "") {
      text = "<spring:message code='service.grid.Status'/>"
      msg += "* <spring:message code='sys.msg.necessary' arguments='" + text + "' htmlEscape='false'/> </br>"
    }

    if (msg != "") {
      Common.alert(msg);
      return false;
    }

    /*var jsonObj = {
      "remark" : $("#remark").val(),
      "status" : $("#status").val(),
      "counselingNo" : $("#counselingNo").text(),
      "mainDept" : $("#mainDept").val(),
      "subDept" : $("#subDept").val(),
      "regDate" : $("#regDate").text(),
      "orderId" : $("#ordId").val(),
      "hcId" : $("#hcId").val(),
      "inputMainDept" : $("#inputMainDept").val(),
      "inputSubDept" : $("#inputSubDept").val()
    };*/

    var regDate = $("#orderId").val();

    var formData = Common.getFormData("tagMngmForm");
    var obj = $("#tagMngmForm").serializeJSON();

    $.each(obj, function(key, value) {
      formData.append(key, value);
    });

    Common.ajaxFile("/services/tagMgmt/addRemarkResult.do", formData,
      function(result) {
        Common.alert(result.message);
        $("#tagLogRegistPop").remove();
        fn_search();
      });
  }

  function fn_atchViewDown(fileGrpId, fileId) {
    if (typeof fileGrpId == 'undefined') {
      return;
    }
    var data = {
      atchFileGrpId : fileGrpId,
      atchFileId : fileId
    };

    Common.ajax("GET", "/eAccounting/webInvoice/getAttachmentInfo.do", data, function(result) {
      if (result == null){
        return;
      }
      var fileSubPath = result.fileSubPath;
      fileSubPath = fileSubPath.replace('\', ' / '');
      window.open("/file/fileDownWeb.do?subPath=" + fileSubPath + "&fileName=" + result.physiclFileName + "&orignlFileNm=" + result.atchFileName);
    });
  }
</script>
<div id="popup_wrap" class="popup_wrap">
 <!-- popup_wrap start -->
 <header class="pop_header">
  <!-- pop_header start -->
  <h1><spring:message code='service.title.tDetailInfo'/></h1>
  <ul class="right_opt">
   <li><p class="btn_blue2">
     <a href="#"><spring:message code='expense.CLOSE'/></a>
    </p></li>
  </ul>
 </header>
 <!-- pop_header end -->
 <section class="pop_body">
  <!-- pop_body start -->
  <!-- <input type="hidden" id="hcId" value="${tagMgmtDetail.hcId}">
  <input type="hidden" id="ordId" value="${tagMgmtDetail.ordId}"> -->
  <section class="tap_wrap">
   <!-- tap_wrap start -->
   <ul class="tap_type1">
    <li><a href="#" class="on"><spring:message code='service.title.tInfo'/></a></li>
    <li><a href="#" id="respondInfo"><spring:message code='service.title.respInfo'/></a></li>
    <li><a href="#" id="orderInfo"><spring:message code='sales.tap.order' /></a></li>
   </ul>
   <!-- Tag Info Start -->
   <article class="tap_area">
    <!-- tap_area start -->
    <section class="tap_wrap mt0">
     <!-- tap_wrap start -->
     <ul class="tap_type1">
      <li><a href="#" class="on"><spring:message code='service.title.General'/></a></li>
      <li><a href="#"><spring:message code='service.title.callInfo'/></a></li>
     </ul>
     <!-- Tag Basic Info Start -->
     <article class="tap_area">
      <!-- tap_area start -->
      <table class="type1">
       <!-- table start -->
       <caption>table</caption>
       <colgroup>
        <col style="width: 180px" />
        <col style="width: *" />
        <col style="width: 180px" />
        <col style="width: *" />
        <col style="width: 160px" />
        <col style="width: *" />
       </colgroup>
       <tbody>
        <tr>
         <th scope="row"><spring:message code='service.title.inqContactNo'/></th>
         <td><span id="counselingNo"><c:out value="${tagMgmtDetail.counselingNo}" /></span></td>
         <th scope="row"><spring:message code='service.title.inqCustNm'/></th>
         <td><span><c:out value="${tagMgmtDetail.customerName}" /></span></td>
         <th scope="row"><spring:message code='service.title.inqMemTyp'/></th>
         <td><span><c:out value="${tagMgmtDetail.classifyMem }" /></span></td>
        </tr>
        <tr>
         <th scope="row"><spring:message code='service.title.initMainDept'/></th>
         <td><span><c:out value="${tagMgmtDetail.mainDept }" /></span></td>
         <th scope="row"><spring:message code='service.title.initSubDept'/></th>
         <td><span><c:out value="${tagMgmtDetail.subDept }" /></span></td>
         <th scope="row"><spring:message code='service.grid.mainInq'/></th>
         <td><span><c:out value="${tagMgmtDetail.mainInquiry }" /></span></td>
        </tr>
        <tr>
         <th scope="row"><spring:message code='service.grid.CustomerId'/></th>
         <td><span><c:out value="${tagMgmtDetail.customerNo }" /></span></td>
         <th scope="row"><spring:message code='service.title.OrderNo'/></th>
         <td><span><c:out value="${tagMgmtDetail.ordNo }" /></span></td>
         <th scope="row"><spring:message code='service.grid.subInq'/></th>
         <td><span><c:out value="${tagMgmtDetail.subInquiry }" /></span></td>
        </tr>
        <tr>
         <th scope="row"><spring:message code='service.grid.Status'/></th>
         <td><span><c:out value="${tagMgmtDetail.status }" /></span></td>
         <th scope="row"><spring:message code='service.grid.registerDt'/></th>
         <td><span id="regDate"><c:out value="${tagMgmtDetail.regDate }" /></span></td>
         <th scope="row"><spring:message code='service.grid.fbCde'/></th>
         <td><span><c:out value="${tagMgmtDetail.feedbackCode }" /></span></td>
        </tr>
        <tr>
         <th scope="row"><spring:message code='service.grid.mainDept'/></th>
         <td><span><c:out value="${tagMgmtDetail.latestMainDept }" /></span>
         <input type="hidden" id="mainDept" value="${tagMgmtDetail.deptCode}">
         </td>
         <th scope="row"><spring:message code='service.grid.subDept'/></th>
         <td><span><c:out value="${tagMgmtDetail.latestSubDept }" /></span>
         <input type="hidden" id="subDept" value="${tagMgmtDetail.subDeptCde}">
         </td>
         <th scope="row"></th>
         <td><span></span></td>
        </tr>
        <tr>
         <th scope="row"><spring:message code='service.title.carelineAttc'/></th>
         <td colspan="5" id="attachTd"><input type="hidden"
          id="atchFileGrpId" value="${tagMgmtDetail.atchFileGrpId }">
          <!--             <div class="auto_file2 auto_file3">auto_file start <input type="file" title="file add" /> </div>auto_file end -->
         </td>
        </tr>
        <tr>
         <th scope="row"><spring:message code='service.title.hqAttc'/></th>
         <td colspan="5" id="attachTd2">
          <input type="hidden" id="atchFileGrpIdHQ" value="${tagMgmtDetail.atchFileGrpId }">
         </td>
        </tr>
       </tbody>
      </table>
      <!-- table end -->
      <section class="tap_wrap">
       <!-- tap_wrap start -->
       <ul class="tap_type1">
        <li><a href="#" class="on"><spring:message code='service.title.OrderInformation'/></a></li>
        <li><a href="#"><spring:message code='service.title.HpCodyInfo'/></a></li>
       </ul>
       <!-- Order Info Start -->
       <article class="tap_area">
        <!-- tap_area start -->
        <table class="type1">
         <!-- table start -->
         <caption>table</caption>
         <colgroup>
          <col style="width: 180px" />
          <col style="width: *" />
          <col style="width: 180px" />
          <col style="width: *" />
          <col style="width: 180px" />
          <col style="width: *" />
         </colgroup>
         <tbody>
          <tr>
           <th scope="row"><spring:message code='service.grid.SalesOrder'/></th>
           <td><span><c:out value="${tagMgmtDetail.ordNo }" /></span></td>
           <th scope="row"><spring:message code='service.title.ApplicationType'/></th>
           <td><span><c:out value="${orderInfo.codeDesc }" /></span></td>
           <th scope="row"><spring:message code='service.grid.Product'/></th>
           <td><span><c:out value="${orderInfo.stkDesc }" /></span></td>
          </tr>
          <tr>
           <th scope="row"><spring:message code='service.title.CustomerName'/></th>
           <td><span><c:out value="${orderInfo.name }" /></span></td>
           <th scope="row"><spring:message code='service.title.NRIC_CompanyNo'/></th>
           <td colspan="3"><span><c:out value="${orderInfo.nric }" /></span></td>
          </tr>
         </tbody>
        </table>
        <!-- table end -->
       </article>
       <!-- tap_area end -->
       <!-- Order Info End -->
       <!-- HP/Cody Info Start -->
       <article class="tap_area">
        <!-- tap_area start -->
        <article class="grid_wrap">
         <!-- grid_wrap start -->
         <div class="divine_auto">
          <!-- divine_auto start -->
          <div style="width: 50%;">
           <aside class="title_line">
            <!-- title_line start -->
            <h3 class="pt0"><spring:message code='sal.title.text.salesmanInfo'/></h3>
           </aside>
           <!-- title_line end -->
           <table class="type1">
            <!-- table start -->
            <caption>table</caption>
            <colgroup>
             <col style="width: 180px" />
             <col style="width: *" />
            </colgroup>
            <tbody>
             <tr>
              <th rowspan="3" scope="row"><spring:message code='service.title.OrderNo'/> <spring:message code='service.grid.CrtBy'/></th>
              <td><span class="txt_box">${salesmanInfo.orgCode}
                (Organization Code)<i>(${salesmanInfo.memCode1})
                 ${salesmanInfo.name1} - ${salesmanInfo.telMobile1}</i>
              </span></td>
             </tr>
             <tr>
              <td><span class="txt_box">${salesmanInfo.grpCode}
                (Group Code)<i>(${salesmanInfo.memCode2})
                 ${salesmanInfo.name2} - ${salesmanInfo.telMobile2}</i>
              </span></td>
             </tr>
             <tr>
              <td><span class="txt_box">${salesmanInfo.deptCode}
                (Department Code)<i>(${salesmanInfo.memCode3})
                 ${salesmanInfo.name3} - ${salesmanInfo.telMobile3}</i>
              </span></td>
             </tr>
             <tr>
              <th scope="row"><spring:message code='sal.text.salManCode'/></th>
              <td><span>${salesmanInfo.memCode}</span></td>
             </tr>
             <tr>
              <th scope="row"><spring:message code='sal.text.salManName'/></th>
              <td><span>${salesmanInfo.name}</span></td>
             </tr>
             <tr>
              <th scope="row"><spring:message code='sal.title.text.salesmanNric'/></th>
              <td><span>${salesmanInfo.nric}</span></td>
             </tr>
             <tr>
              <th scope="row"><spring:message code='sal.title.text.telM'/></th>
              <td><span>${salesmanInfo.telMobile}</span></td>
             </tr>
             <tr>
              <th scope="row"><spring:message code='sal.title.text.telO'/></th>
              <td><span>${salesmanInfo.telOffice}</span></td>
             </tr>
             <tr>
              <th scope="row"><spring:message code='sal.title.text.telR'/></th>
              <td><span>${salesmanInfo.telHuse}</span></td>
             </tr>
            </tbody>
           </table>
           <!-- table end -->
          </div>
          <div style="width: 50%;">
           <aside class="title_line">
            <!-- title_line start -->
            <h3 class="pt0"><spring:message code='service.title.codyInfo'/></h3>
           </aside>
           <!-- title_line end -->
           <table class="type1">
            <!-- table start -->
            <caption>table</caption>
            <colgroup>
             <col style="width: 180px" />
             <col style="width: *" />
            </colgroup>
            <tbody>
             <tr>
              <th rowspan="3" scope="row"><spring:message code='sal.title.text.svcBy'/></th>
              <td><span class="txt_box">${codyInfo.orgCode}
                (Organization Code)<i>(${codyInfo.memCode1})
                 ${codyInfo.name1} - ${codyInfo.telMobile1}</i>
              </span></td>
             </tr>
             <tr>
              <td><span class="txt_box">${codyInfo.grpCode}
                (Group Code)<i>(${codyInfo.memCode2})
                 ${codyInfo.name2} - ${codyInfo.telMobile2}</i>
              </span></td>
             </tr>
             <tr>
              <td><span class="txt_box">${codyInfo.deptCode}
                (Department Code)<i>(${codyInfo.memCode3})
                 ${codyInfo.name3} - ${codyInfo.telMobile3}</i>
              </span></td>
             </tr>
             <tr>
              <th scope="row"><spring:message code='sal.title.codyCode'/></th>
              <td><span>${codyInfo.memCode}</span></td>
             </tr>
             <tr>
              <th scope="row"><spring:message code='sal.title.text.codyNm'/></th>
              <td><span>${codyInfo.name}</span></td>
             </tr>
             <tr>
              <th scope="row"><spring:message code='sal.title.text.codyNric'/></th>
              <td><span>${codyInfo.nric}</span></td>
             </tr>
             <tr>
              <th scope="row"><spring:message code='sal.title.text.telM'/></th>
              <td><span>${codyInfo.telMobile}</span></td>
             </tr>
             <tr>
              <th scope="row"><spring:message code='sal.title.text.telO'/></th>
              <td><span>${codyInfo.telOffice}</span></td>
             </tr>
             <tr>
              <th scope="row"><spring:message code='sal.title.text.telR'/></th>
              <td><span>${codyInfo.telHuse}</span></td>
             </tr>
            </tbody>
           </table>
           <!-- table end -->
          </div>
         </div>
         <!-- divine_auto end -->
        </article>
        <!-- grid_wrap end -->
       </article>
       <!-- tap_area end -->
       <!-- HP/Cody Info End -->
      </section>
      <!-- tap_wrap end -->
     </article>
     <!-- tap_area end -->
     <!-- Tag Basic Info End -->
     <!-- Caller Info Start -->
     <article class="tap_area">
      <!-- tap_area start -->
      <table class="type1">
       <!-- table start -->
       <caption>table</caption>
       <colgroup>
        <col style="width: 180px" />
        <col style="width: *" />
       </colgroup>
       <tbody>
        <tr>
         <th scope="row"><spring:message code='service.title.Name'/></th>
         <td><span><c:out value="${callerInfo.name }" /></span></td>
         <th scope="row"><spring:message code='sales.NRIC'/></th>
         <td><span><c:out value="${callerInfo.nric }" /></span></td>
         <th scope="row"><spring:message code='sal.text.company'/></th>
         <td><span><c:out value="${callerInfo.name }" /></span></td>
        </tr>
        <tr>
         <th scope="row"><spring:message code='service.title.ContactNo'/>(1)</th>
         <td><span><c:out value="${callerInfo.telM1 }" /></span></td>
         <th scope="row"><spring:message code='service.title.ContactNo'/>(2)</th>
         <td><span><c:out value="${callerInfo.telR }" /></span></td>
         <th scope="row"><spring:message code='sal.text.email'/></th>
         <td><span><c:out value="${callerInfo.email }" /></span></td>
        </tr>
       </tbody>
      </table>
      <!-- table end -->
     </article>
     <!-- tap_area end -->
     <!-- Caller Info End -->
    </section>
    <!-- tap_wrap end -->
   </article>
   <!-- tap_area end -->
   <!-- Tag Info End -->
   <!-- Respond Info Start -->
   <article class="tap_area">
    <!-- tap_area start -->
    <aside class="title_line">
     <!-- title_line start -->
     <h3><spring:message code='service.title.respInfo'/></h3>
    </aside>
    <!-- title_line end -->
    <article class="grid_wrap">
     <!-- grid_wrap start -->
     <div id="respond_grid_wrap"
      style="width: 100%; height: 300px; margin: 0"></div>
    </article>
    <!-- grid_wrap end -->
   </article>
   <!-- tap_area end -->
   <!-- Respond Info End -->
   <!-- Order Information Start -->
   <article class="tap_area">
    <!-- tap_area start -->
    <aside class="title_line">
     <!-- title_line start -->
     <h3>Order Information</h3>
     <ul class="right_opt">
      <li><p class="btn_blue2"><a id="btnLedger1" href="#"><spring:message code="sal.btn.ledger" />(1)</a></p></li>
      <li><p class="btn_blue2"><a id="btnLedger2" href="#"><spring:message code="sal.btn.ledger" />(2)</a></p></li>
     </ul>
    </aside>
    <!-- title_line end -->
    <!------------------------------------------------------------------------------
      Order Detail Page Include START
    ------------------------------------------------------------------------------->
    <%@ include file="/WEB-INF/jsp/sales/order/orderDetailContent.jsp"%>
    <!------------------------------------------------------------------------------
      Order Detail Page Include END
    ------------------------------------------------------------------------------->
   </article>
   <!-- tap_area end -->
   <!-- Order Information End -->
  </section>
  <!-- tap_wrap end -->
  <section class="search_table">
   <!-- search_table start -->
  </section>
  <!-- search_table end -->
  <section class="search_result">
   <!-- search_result start -->
   <article class="grid_wrap">
    <!-- grid_wrap start -->
    <aside class="title_line">
     <!-- title_line start -->
     <h3><spring:message code='service.title.addResp'/></h3>
    </aside>
    <!-- title_line end -->
    <form action="#" method="post" id='tagMngmForm' enctype="multipart/form-data">
    <input type="hidden" id="hcId" name="hcId" value="${tagMgmtDetail.hcId}">
    <input type="hidden" id="ordId" name="ordId" value="${tagMgmtDetail.ordId}">
    <input type="hidden" id="orderId" name="orderId" value="${tagMgmtDetail.ordId}">
    <input type="hidden" id="counselingNo" name="counselingNo" value="${tagMgmtDetail.counselingNo}">
    <input type="hidden" id="regDate" name="regDate" value="${tagMgmtDetail.regDate }">
    <input type="hidden" id="mainDept" name="mainDept" value="${tagMgmtDetail.deptCode}">
    <input type="hidden" id="subDept" name="subDept" value="${tagMgmtDetail.subDeptCde}">
    <table class="type1">
     <!-- table start -->
     <caption>table</caption>
     <colgroup>
      <col style="width: 180px" />
      <col style="width: *" />
     </colgroup>
     <tbody>
      <tr>
       <th scope="row"><spring:message code='service.grid.mainDept'/><span class='must'>*</span></th>
       <td>
       <c:choose>
       <c:when test="${tagMgmtDetail.status == 'Closed' || tagMgmtDetail.status == 'Cancelled' || tagMgmtDetail.status == 'Solved'}">
       <select class="w100p" id="inputMainDept"name="inputMainDept" disabled="disabled"></select>
       </c:when>
       <c:otherwise>
       <select class="w100p" id="inputMainDept"name="inputMainDept"></select>
       </c:otherwise>
       </c:choose>
       </td>
      </tr>
      <tr>
       <th scope="row"><spring:message code='service.grid.subDept'/> </th>
       <td>
       <c:choose>
       <c:when test="${tagMgmtDetail.status == 'Closed' || tagMgmtDetail.status == 'Cancelled' || tagMgmtDetail.status == 'Solved'}">
       <select class="w100p" id="inputSubDept"name="inputSubDept" disabled="disabled"><option value="" selected><spring:message code='sal.combo.text.chooseOne'/></option></select></td>
       </c:when>
       <c:otherwise>
       <select class="w100p" id="inputSubDept"name="inputSubDept"><option value="" selected><spring:message code='sal.combo.text.chooseOne'/></option></select>
       </c:otherwise>
       </c:choose>
       </td>
      </tr>
      <tr>
       <th scope="row"><spring:message code='service.grid.Status'/> <span class='must'>*</span></th>
       <td>
       <c:choose>
       <c:when test="${tagMgmtDetail.status == 'Closed' || tagMgmtDetail.status == 'Cancelled' || tagMgmtDetail.status == 'Solved'}">
       <select id="status" name="status" disabled="disabled"><option value="" selected><spring:message code='sal.combo.text.chooseOne'/></option>
         <c:forEach var="list" items="${tMgntStat}" varStatus="status">
           <option value="${list.code}">${list.codeName}</option>
          </c:forEach>

         <!-- <option value="1">Active</option>
         <option value="44">Pending</option>
         <option value="34">Solve</option>
         <option value="35">Not yet to solve</option>
         <option value="36">Close</option>
         <option value="10">Cancel</option> -->

       </select>
       </c:when>
       <c:otherwise>
       <select id="status" name="status"><option value="" selected><spring:message code='sal.combo.text.chooseOne'/></option>
         <c:forEach var="list" items="${tMgntStat}" varStatus="status">
           <option value="${list.code}">${list.codeName}</option>
          </c:forEach>

         <!-- <option value="1">Active</option>
         <option value="44">Pending</option>
         <option value="34">Solve</option>
         <option value="35">Not yet to solve</option>
         <option value="36">Close</option>
         <option value="10">Cancel</option> -->

       </select>
       </c:otherwise>
       </c:choose>
       </td>
      </tr>

      <tr>
       <th scope="row"><spring:message code='budget.Attathment' /></th>
       <td colspan="3">
       <c:choose>
         <c:when test="${tagMgmtDetail.status == 'Closed' || tagMgmtDetail.status == 'Cancelled' || tagMgmtDetail.status == 'Solved'}">
         <input id="certRefFile" disabled="disabled"/></div>
         </c:when>
         <c:otherwise>
          <div class="auto_file attachment_file w100p">
         <!-- auto_file start -->
         <input id="certRefFile" name="certRefFile" type="file" title="file add" /></div>
         <!-- auto_file end -->
         </c:otherwise>
        </c:choose>
       </td>
      </tr>

      <tr>
       <th scope="row"><spring:message code='service.grid.Remark'/></th>
       <td>
       <c:choose>
       <c:when test="${tagMgmtDetail.status == 'Closed' || tagMgmtDetail.status == 'Cancelled' || tagMgmtDetail.status == 'Solved'}">
       <textarea name="remark" id="remark" cols="20" rows="5"placeholder="" disabled="disabled"></textarea>
       </c:when>
        <c:otherwise>
        <textarea name="remark" id="remark" cols="20" rows="5"placeholder=""></textarea>
        </c:otherwise>
       </c:choose>
       </td>
      </tr>
     </tbody>

    </table>
    </form>
    <!-- table end -->
    <!-- <ul class="right_btns">
     <li><p class="btn_blue2 big">
       <a id="remark" onclick="fn_saveRemarkResult()"><spring:message code='sys.btn.save'/></a>
      </p></li>
    </ul> -->

    <div id='sav_div'>
    <ul class="center_btns" id="hiddenBtn">
    <li><p class="btn_blue2 big">
      <a href="#" onclick="fn_saveRemarkResult()"><spring:message code='sys.btn.save'/></a>
     </p></li>
   </ul>
  </div>
   </article>
   <!-- grid_wrap end -->
  </section>
  <!-- search_result end -->
 </section>
 <!-- content end -->
</div>