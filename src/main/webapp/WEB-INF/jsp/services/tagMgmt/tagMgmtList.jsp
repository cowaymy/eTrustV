<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>
<script type="text/javaScript">
  var gridID;
  var gridIDExcel;
  var counselingId;

  function tagMgmtGrid() {

    var columnLayout = [ {
      dataField : "counselingNo",
      headerText : "<spring:message code='service.grid.counselingNo'/>",
      width : "10%"
    }, {
      dataField : "customerName",
      headerText : "<spring:message code='service.grid.CustomerName'/>",
      width : "13%"
    }, {
      dataField : "mainInquiry",
      headerText : "<spring:message code='service.grid.mainInq'/>",
      width : "12%"
    }, {
      dataField : "subInquiry",
      headerText : "<spring:message code='service.grid.subInq'/>",
      width : "13%"
    }, {
      dataField : "feedbackCode",
      headerText : "<spring:message code='service.grid.fbCde'/>",
      width : "10%"
    }, {
      dataField : "mainDept",
      headerText : "<spring:message code='service.grid.mainDept'/>",
      width : "13%"
    }, {
      dataField : "subDept",
      headerText : "<spring:message code='service.grid.subDept'/>",
      width : "15%"
    }, {
      dataField : "regDate",
      headerText : "<spring:message code='service.grid.registerDt'/>",
      dataType : "date"
    }, {
      dataField : "status",
      headerText : "<spring:message code='service.grid.Status'/>",
      width : "5%"
    }, {
      dataField : "ordNo",
      headerText : "<spring:message code='service.grid.SalesOrder'/>",
      width : "5%"
    } ];

    var excelLayout = [ {
      dataField : "regDate",
      headerText : "<spring:message code='service.grid.registerDt'/>",
      width : 150,
      height : 80
    }, {
      dataField : "ordNo",
      headerText : "<spring:message code='service.grid.SalesOrder'/>",
      width : 200,
      height : 80
    }, {
      dataField : "counselingNo",
      headerText : "<spring:message code='service.grid.counselingNo'/>",
      width : 200,
      height : 80
    }, {
      dataField : "customerName",
      headerText : "<spring:message code='service.grid.CustomerName'/>",
      width : 200,
      height : 80
    }, {
      dataField : "mainInquiry",
      headerText : "<spring:message code='service.grid.mainInq'/>",
      width : 200,
      height : 80
    }, {
      dataField : "subInquiry",
      headerText : "<spring:message code='service.grid.subInq'/>",
      width : 200,
      height : 80
    }, {
      dataField : "feedbackCode",
      headerText : "<spring:message code='service.grid.fbCde'/>",
      width : 200,
      height : 80
    }, {
      dataField : "mainDept",
      headerText : "<spring:message code='service.grid.mainDept'/>",
      width : 200,
      height : 80
    }, {
      dataField : "subDept",
      headerText : "<spring:message code='service.grid.subDept'/>",
      width : 200,
      height : 80
    }, {
      dataField : "updDt",
      headerText : "<spring:message code='service.title.UpdateDate'/>",
      width : 150,
      height : 80
    }, {
      dataField : "lstUpdId",
      headerText : "<spring:message code='service.grid.UpdateBy'/>",
      width : 150,
      height : 80
    }, {
      dataField : "status",
      headerText : "<spring:message code='service.grid.Status'/>",
      width : 100,
      height : 80
    }, {
      dataField : "callRem",
      headerText : "<spring:message code='service.grid.Remark'/>",
      width : 500,
      height : 80
    } ];

    var gridPros = {
      usePaging : true,
      pageRowCount : 20,
      showStateColumn : false,
      displayTreeOpen : false,
      //selectionMode : "singleRow",
      skipReadonlyColumns : true,
      wrapSelectionMove : true,
      showRowNumColumn : true,
      editable : false
    };

    var excelGridPros = {
      enterKeyColumnBase : true,
      useContextMenu : true,
      enableFilter : true,
      showStateColumn : true,
      displayTreeOpen : true,
      wordWrap : true,
      noDataMessage : "<spring:message code='sys.info.grid.noDataMessage' />",
      groupingMessage : "<spring:message code='sys.info.grid.groupingMessage' />",
      exportURL : "/common/exportGrid.do"
    };

    gridID = GridCommon.createAUIGrid("tagMgmt_grid_wap", columnLayout, "", gridPros);
    gridIDExcelHide = GridCommon.createAUIGrid("grid_wrap_hide", excelLayout, "", excelGridPros);
  }

  $(document).ready(
    function() {
      tagMgmtGrid();

      $("#search").click(
        function() {
            fn_search();
          });

          //excel Download
          $('#excelDown').click(
            function() {
              //GridCommon.exportTo("tagMgmt_grid_wap", 'xlsx',"Tag Management");
              var excelProps = {
                fileName : "Tag Management",
                exceptColumnFields : AUIGrid.getHiddenColumnDataFields(gridIDExcelHide)
              };
              AUIGrid.exportToXlsx(gridIDExcelHide, excelProps);
          });

          // cell click
          AUIGrid.bind(gridID, "cellClick",
            function(event) {
              counselingId = AUIGrid.getCellValue(gridID, event.rowIndex, "counselingNo");
          });

          doGetCombo('/services/tagMgmt/selectMainDept.do', '', '', 'main_department', 'S', '');

          $("#main_department").change(
            function() {
              if ($("#main_department").val() == '') {
                $("#sub_department").val('');
                $("#sub_department").find("option").remove();
              } else {
                doGetCombo('/services/tagMgmt/selectSubDept.do', $("#main_department").val(), '', 'sub_department', 'S', '');
              }
          });

          doGetCombo('/services/tagMgmt/selectMainInquiry.do', '', '', 'main_inquiry', 'S', '');

          $("#main_inquiry").change(
            function() {
              doGetCombo('/services/tagMgmt/selectSubInquiry.do', $("#main_inquiry").val(), '', 'sub_inquiry', 'S', '');
          });
  });

  function fn_search() {
    Common.ajax("GET", "/services/tagMgmt/selectTagStatus", $("#tagMgmtForm").serialize(),
      function(result) {
        AUIGrid.setGridData(gridID, result);
        AUIGrid.setGridData(gridIDExcelHide, result);
      });
  }

  function fn_tagLog() {
    var selectedItems = AUIGrid.getSelectedItems(gridID);
    if (selectedItems.length <= 0) {
      Common.alert("<spring:message code='service.msg.NoRcd'/>");
      return;
    }

    //Common.popupDiv("/services/tagMgmt/tagLogRegist.do?&salesOrdId="+salesOrdId +"&brnchId="+brnchId, null, null , true , '_ConfigBasicPop');
    Common.popupDiv("/services/tagMgmt/tagLogRegistPop.do?counselingId=" + counselingId + "", null, null, true, "tagLogRegistPop");
  }

  function fn_download() {
    var gridObj = AUIGrid.getSelectedItems(gridID);

    if (gridObj == null || gridObj.length <= 0) {
      Common.alert("<spring:message code='service.msg.NoRcd'/>");
      return;
    }

    var counselingNo = gridObj[0].item.counselingNo;

    var whereSQL = "";
    var whereSQL2 = "";
    var whereSQL3 = "";
    var date = new Date().getDate();
    if (date.toString().length == 1) {
      date = "0" + date;
    }

    $("#reportFileName").val("");
    $("#reportDownFileName").val("");
    $("#viewType").val("");

    whereSQL = " AND z.Counselling_No = '" + counselingNo + "'";
    whereSQL2 = " WHERE T1.CUR_SEQNO = '" + counselingNo + "'";
    whereSQL3 = "  AND T4.CUR_SEQNO = '" + counselingNo + "'";
    $("#dataForm3 #viewType").val("PDF");
    $("#dataForm3 #reportFileName").val("/services/TagCFFReport_PDF.rpt");
    $("#reportDownFileName").val("Tag/CFF_" + counselingNo + "_" + date + (new Date().getMonth() + 1) + new Date().getFullYear());

    $("#dataForm3 #V_COUNSELLINGNO").val(counselingNo);
    $("#dataForm3 #V_WHERESQL").val(whereSQL);
    $("#dataForm3 #V_WHERESQL2").val(whereSQL2);
    $("#dataForm3 #V_WHERESQL3").val(whereSQL3);
    $("#dataForm3 #V_SELECTSQL").val("");
    $("#dataForm3 #V_SELECTSQL2").val("");
    $("#dataForm3 #V_FULLSQL").val("");

    var option = {
      isProcedure : true
      // procedure 로 구성된 리포트 인경우 필수.  => /payment/PaymentListing_Excel.rpt 는 프로시져로 구성된 파일임.
    };

    Common.report("dataForm3", option);
  }

</script>
<section id="content">
 <!-- content start -->
 <ul class="path">
  <li><img
   src="${pageContext.request.contextPath}/images/common/path_home.gif"
   alt="Home" /></li>
  <li><spring:message code='service.title.service'/></li>
  <li><spring:message code='service.title.tagMgmt'/></li>
 </ul>
 <aside class="title_line">
  <!-- title_line start -->
  <p class="fav">
   <a href="#" class="click_add_on">My menu</a>
  </p>
  <h2><spring:message code='service.title.tagMgmt'/></h2>
  <ul class="right_btns">
   <c:if test="${PAGE_AUTH.funcUserDefine1 == 'Y'}">
    <li><p class="btn_blue">
      <a href="javascript:fn_download()"><spring:message code='service.text.tagCff'/></a>
     </p></li>
   </c:if>
   <c:if test="${PAGE_AUTH.funcUserDefine1 == 'Y'}">
    <li><p class="btn_blue">
      <a href="javascript:fn_tagLog()"><spring:message code='service.text.viewRespTick'/></a>
     </p></li>
   </c:if>
   <c:if test="${PAGE_AUTH.funcView == 'Y'}">
    <li><p class="btn_blue">
      <a href="#" id="search"><span class="search"></span><spring:message code='sys.btn.search'/></a>
     </p></li>
   </c:if>
   <!-- <li><p class="btn_blue"><a href="#" onclick="javascript:fn_Clear()"><span class="clear"></span>Clear</a></p></li> -->
  </ul>
 </aside>
 <!-- title_line end -->
 <section class="search_table">
  <!-- search_table start -->
  <form id="dataForm3">
   <input type="hidden" id="reportFileName" name="reportFileName" value="" />
   <input type="hidden" id="viewType" name="viewType" value="" />
   <input type="hidden" id="reportDownFileName" name="reportDownFileName" value="" />
   <input type="hidden" id="V_COUNSELLINGNO" name="V_COUNSELLINGNO" value="" />
   <input type="hidden" id="V_WHERESQL" name="V_WHERESQL" value="" />
   <input type="hidden" id="V_WHERESQL2" name="V_WHERESQL2" value="" />
   <input type="hidden" id="V_WHERESQL3" name="V_WHERESQL3" value="" />
   <input type="hidden" id="V_SELECTSQL" name="V_SELECTSQL" value="" />
   <input type="hidden" id="V_SELECTSQL2" name="V_SELECTSQL2" value="" />
   <input type="hidden" id="V_FULLSQL" name="V_FULLSQL" value="" />
  </form>
  <form id="tagMgmtForm" name="tagMgmtForm" method="post">
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
      <th scope="row"><spring:message code='service.grid.counselingNo'/></th>
      <td><input type="text" id="customer" name="counseling_no"
       placeholder="<spring:message code='service.grid.counselingNo'/>" class="w100p" /></td>
      <th scope="row"><spring:message code='service.grid.mainInq'/></th>
      <td><select class="w100p" id="main_inquiry" name="main_inquiry">
        <option value=""><spring:message code='sal.combo.text.chooseOne'/></option>
      </select></td>
      <th scope="row"><spring:message code='service.grid.subInq'/></th>
      <td><select class="w100p" id="sub_inquiry" name="sub_inquiry">
        <option value=""><spring:message code='sal.combo.text.chooseOne'/></option>
      </select></td>
     </tr>
     <tr>
      <th scope="row"><spring:message code='service.grid.CustomerName'/></th>
      <td><input type="text" id="customer" name="customer"
       placeholder="<spring:message code='service.grid.CustomerName'/>" class="w100p" /></td>
      <th scope="row"><spring:message code='service.grid.mainDept'/></th>
      <td><select class="w100p" id="main_department"
       name="main_department"></select></td>
      <th scope="row"><spring:message code='service.grid.subDept'/></th>
      <td><select class="w100p" id="sub_department"
       name="sub_department">
       <option value=""><spring:message code='sal.combo.text.chooseOne'/></option>
       </select></td>
     </tr>
     <tr>
      <th scope="row"><spring:message code='service.grid.fbCde'/></th>
      <td><input type="text" id="feedback_code"
       name="feedback_code" title="" placeholder="<spring:message code='service.grid.fbCde'/>"
       class="w100p" /></td>
      <th scope="row"><spring:message code='service.grid.registerDt'/></th>
      <td>
       <div class="date_set w100p">
        <!-- date_set start -->
        <p>
         <input type="text" title="Create start Date" value="${bfDay}"
          placeholder="DD/MM/YYYY" class="j_date w100p" id="regStartDt"
          name="regStartDt" />
        </p>
        <span>To</span>
        <p>
         <input type="text" title="Create end Date" value="${toDay}"
          placeholder="DD/MM/YYYY" class="j_date w100p" id="regEndDt"
          name="regEndDt" />
        </p>
       </div>
       <!-- date_set end -->
      </td>
      <th scope="row"><spring:message code='service.grid.Status'/></th>
      <td><select class="multy_select w100p" multiple="multiple"
       id="statusList" name="statusList">

        <c:forEach var="list" items="${tMgntStat}" varStatus="status">
          <option value="${list.code}" selected>${list.codeName}</option>
        </c:forEach>

        <!-- <option value="1">Active</option>
        <option value="44">Pending</option>
        <option value="34">Solved</option>
        <option value="35">Unsolved</option>
        <option value="36">Closed</option>
        <option value="10">Cancelled</option> -->

      </select></td>
     </tr>
    </tbody>
   </table>
   <!-- table end -->
  </form>
 </section>
 <!-- search_table end -->
 <section class="search_result">
  <!-- search_result start -->
  <c:if test="${PAGE_AUTH.funcPrint == 'Y'}">
   <ul class="right_btns">
    <li><p class="btn_grid">
      <a href="#" id="excelDown"><spring:message code='service.btn.Generate'/></a>
     </p></li>
   </ul>
  </c:if>
  <article class="grid_wrap">
   <!-- grid_wrap start  그리드 영역-->
   <div id="tagMgmt_grid_wap"
    style="width: 100%; height: 500px; margin: 0 auto;"></div>
   <div id="grid_wrap_hide" style="display: none;"></div>
  </article>
  <!-- grid_wrap end -->
 </section>
 <!-- search_result end -->
</section>
<!-- content end -->
