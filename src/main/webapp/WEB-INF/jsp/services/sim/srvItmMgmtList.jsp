<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>

<!--
 DATE        BY     VERSION        REMARK
 ----------------------------------------------------------------
 20/06/2019  ONGHC  1.0.0          CREATE SERVICE ITEM MANAGEMENT LISTING
 -->

<script type="text/javaScript">
  var option = {
    width : "1200px",
    height : "500px"
  };

  var myGridID;

  $(document).ready( function() {
    srvItmMgmtGrid(); // GRID VIEW COLUMN CONFIGURATION
    // SET CBO LISING HERE --
    doGetCombo('/services/sim/getBchTyp.do', '', '', 'cboBchTyp', 'S', ''); // BRANCH TYPE
    doGetCombo('/services/sim/getItm.do', '', '', 'cboItm', 'S', ''); // ITEM TYPE

    // SET TRIGGER FUNCTION HERE --
    $("#cboBchTyp").change(function() {
      doGetCombo('/services/sim/getBch.do', $("#cboBchTyp").val(), '', 'cboBch', 'S', '');
    });

    // DOUBLE CLICK
    AUIGrid.bind(myGridID, "cellDoubleClick", function(event) {
      var brCde = AUIGrid.getCellValue(myGridID, event.rowIndex, "brCde");
      var itmCde = AUIGrid.getCellValue(myGridID, event.rowIndex, "itmCde");

      var param = "?brCde=" + brCde + "&itmCde=" + itmCde;

      Common.popupDiv("/services/sim/srvItmView.do" + param, null, null, true, '_srvItmViewDiv1');
    });
  });

  function srvItmMgmtGrid() {
      var columnLayout = [
          {
            dataField : "brCde",
            headerText : "<spring:message code='service.grid.bch'/>",
            editable : false,
            width : 300,
            visible : false
          },
          {
            dataField : "br",
            headerText : "<spring:message code='service.grid.bch'/>",
            editable : false,
            width : 300
          },
          {
            dataField : "itmCde",
            headerText : "<spring:message code='service.grid.itmCde'/>",
            editable : false,
            width : 200,
            visible : false
          },
          {
            dataField : "stkCde",
            headerText : "<spring:message code='service.grid.itmCde'/>",
            editable : false,
            width : 200
          },
          {
            dataField : "stkDesc",
            headerText : "<spring:message code='service.grid.itmDesc'/>",
            editable : false,
            width : 400
          },
          {
            dataField : "qty",
            headerText : "<spring:message code='service.grid.Quantity'/>",
            editable : false,
            width : 200
          },
          {
            dataField : "crtDt",
            headerText : "<spring:message code='service.grid.CrtDt'/>",
            editable : false,
            width : 100
          },
          {
            dataField : "crtBy",
            headerText : "<spring:message code='service.grid.CrtBy'/>",
            editable : false,
            width : 100
          },
          {
            dataField : "rcdTms",
            headerText : "",
            width : 100,
            visible : false
          }
      ];

      var gridPros = {
        showRowCheckColumn : false,
        usePaging : true,
        pageRowCount : 20,
        showRowAllCheckBox : false,
        editable : false,
        selectionMode : "multipleCells"
      };

      myGridID = AUIGrid.create("#grid_wrap_srvItmList", columnLayout, gridPros);
  }

  function fn_addTrx() {
    Common.popupDiv("/services/sim/srvItmEntryPop.do", null, null, true, '_NewEntryPopDiv1');
    return;
  }

  function fn_searchResult() {
    var bchTyp = $('#cboBchTyp').val();
    var bch = $('#cboBch').val();
    var text;

    /*if (bchTyp == "" || bchTyp == null) {
      text = "<spring:message code='service.grid.brchTyp'/>";
      Common.alert("<spring:message code='sys.msg.necessary' arguments='" + text + "' htmlEscape='false'/>");
      return;
    }
    if (bch == "" || bch == null) {
      text = "<spring:message code='service.grid.bch'/>";
      Common.alert("<spring:message code='sys.msg.necessary' arguments='" + text + "' htmlEscape='false'/>");
      return;
    }*/

    Common.ajax("GET", "/services/sim/searchSrvItmLst.do", $("#srvItmForm").serialize(), function(result) {
      AUIGrid.setGridData(myGridID, result);
    });
    return;
  }

  function fn_addSrvItm(dt1, dt2, dt3) {
    var pram = "?cboBchTyp=" + dt1 + "&cboBch=" + dt2 + "&cboItm=" + dt3;
    Common.popupDiv("/services/sim/srvItmAddPop.do" + pram, null, null, true, '_resultNewEntryPopDiv1');
  }

  function fn_srvItmRaw() {
    Common.popupDiv("/services/sim/srvItmRawPop.do", null, null, true, '_printSrvItmRawPopDiv1');
  }

  function fn_excelDown() {
    GridCommon.exportTo("grid_wrap_srvItmList", "xlsx", "Service Item Management");
  }
</script>
<section id="content">
 <ul class="path">
  <li><img src="${pageContext.request.contextPath}/resources/images/common/path_home.gif" alt="Home" /></li>
 </ul>

 <aside class="title_line">
  <p class="fav">
   <a href="#" class="click_add_on"></a>
  </p>

  <h2><spring:message code='service.title.srvItmMgmt'/></h2>

  <form action="#" id="srvItmMgmt">
   <div style="display: none">
    <!-- TODO -->
    <input type="text" id="in_asId" name="in_asId" />
    <input type="text" id="in_asNo" name="in_asNo" />
    <input type="text" id="in_ordId" name="in_ordId" />
    <input type="text" id="in_asResultId" name="in_asResultId" />
    <input type="text" id="in_asResultNo" name="in_asResultNo" />
   </div>
  </form>

  <ul class="right_btns">
   <c:if test="${PAGE_AUTH.funcUserDefine1 == 'Y'}">
    <li><p class="btn_blue">
      <a href="#" onclick="fn_addTrx()"><spring:message code='sys.btn.add'/></a>
     </p></li>
   </c:if>
   <c:if test="${PAGE_AUTH.funcView == 'Y'}">
    <li><p class="btn_blue">
      <a href="#" onClick="fn_searchResult()"><span class="search"></span><spring:message code='sys.btn.search'/></a>
     </p></li>
   </c:if>
   <li><p class="btn_blue">
     <a href="#"><span class="clear"></span><spring:message code='sys.btn.clear'/></a>
    </p></li>
  </ul>

 </aside>

 <section class="search_table">
  <form action="#" method="post" id="srvItmForm">
   <table class="type1">

    <caption>table</caption>
    <colgroup>
     <col style="width: 150px" />
     <col style="width: *" />
     <col style="width: 150px" />
     <col style="width: *" />
    </colgroup>
    <tbody>
     <tr>
      <th scope="row"><spring:message code='service.grid.brchTyp'/></th> <!-- BRANCH TYPE -->
      <td><select id="cboBchTyp" name="cboBchTyp" class="w100p" /></td>

      <th scope="row"><spring:message code='service.grid.bch'/></th>
      <td><select id="cboBch" name="cboBch" class="w100p" >
        <option value=""><spring:message code='sal.combo.text.chooseOne'/></option>
      </select></td>

     </tr>

     <tr>
      <th scope="row"><spring:message code='sal.title.item'/></th>
      <td>
        <select id="cboItm" name="cboItm" class="w100p" />
      </td>
      <th scope="row"><spring:message code='service.grid.CrtDt'/></th>
      <td>
       <div class="date_set w100p">
        <p>
         <input type="text" title="<spring:message code='service.grid.CrtDt'/>"
          placeholder="DD/MM/YYYY" class="j_date" id="trxStrDate"
          name="trxStrDate" />
        </p>
        <span><spring:message code='svc.hs.reversal.to'/></span>
        <p>
         <input type="text" title="<spring:message code='service.grid.CrtDt'/>"
          placeholder="DD/MM/YYYY" class="j_date" id="trxEndDate"
          name="trxEndDate" />
        </p>
       </div>
      </td>
     </tr>
    </tbody>
   </table>
   <aside class="link_btns_wrap">
    <p class="show_btn">
     <a href="#"><img
      src="${pageContext.request.contextPath}/resources/images/common/btn_link.gif"
      alt="link show" /></a>
    </p>
    <dl class="link_list">
     <dt>Link</dt>
     <dd>
      <ul class="btns">
      </ul>
      <ul class="btns">
       <c:if test="${PAGE_AUTH.funcUserDefine8 == 'Y'}">
        <li><p class="link_btn type2">
          <a href="#" onclick="fn_srvItmRaw()"><spring:message code='service.title.srvItmRaw'/></a>
         </p></li>
       </c:if>
      </ul>
      <p class="hide_btn">
       <a href="#"><img src="${pageContext.request.contextPath}/resources/images/common/btn_link_close.gif" alt="hide" /></a>
      </p>
     </dd>
    </dl>
   </aside>
   <ul class="right_btns">
    <c:if test="${PAGE_AUTH.funcUserDefine10 == 'Y'}">
     <li><p class="btn_grid">
       <a href="#" onClick="fn_excelDown()"><spring:message code='service.btn.Generate'/></a>
      </p></li>
    </c:if>
   </ul>
   <article class="grid_wrap">
    <div id="grid_wrap_srvItmList"
     style="width: 100%; height: 500px; margin: 0 auto;"></div>
   </article>
  </form>
  <form action="#" id="reportForm" method="post">
   <input type="hidden" id="V_RESULTID" name="V_RESULTID" /> <input
    type="hidden" id="reportFileName" name="reportFileName" /> <input
    type="hidden" id="viewType" name="viewType" /> <input type="hidden"
    id="reportDownFileName" name="reportDownFileName"
    value="DOWN_FILE_NAME" />
  </form>
 </section>
</section>