<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>

<!--
 DATE        BY     VERSION        REMARK
 ----------------------------------------------------------------
 27/06/2019  ONGHC  1.0.0          CREATE FOR SERVICE ITEM MANEGEMENT
 -->

<style type="text/css">
.my-pink-style {
    background:#FFA7A7;
    font-weight:bold;
    color:#22741C;
}
</style>

<script type="text/javaScript">
  var myGridIDPop;
  var myGridIDPopAdd;

  var deleteRowIdx;

  $(document).ready(
    function() {
      srvItmMgmtGrid(); // CREATE GRID
      getSrvItm(); // GET RECORD FOR GRID
    });

  function srvItmMgmtGrid() {
      var columnLayout = [
          {
            dataField : "dsc",
            headerText : "<spring:message code='service.title.DSCCode'/>",
            editable : false,
            width : 100
          },
          {
            dataField : "trxDt",
            headerText : "<spring:message code='service.grid.trxDt'/>",
            editable : false,
            width : 100
          },
          {
            dataField : "stkDesc",
            headerText : "<spring:message code='service.grid.itmCde'/>",
            editable : false,
            width : 300
          },
          {
            dataField : "movTyp",
            headerText : "<spring:message code='service.grid.mov'/>",
            editable : false,
            width : 100
          },
          {
            dataField : "movDtl",
            headerText : "<spring:message code='service.grid.movDtl'/>",
            editable : false,
            width : 400
          },
          {
            dataField : "qty",
            headerText : "<spring:message code='service.grid.Quantity'/>",
            editable : false,
            width : 100
          },
          {
            dataField : "rmk",
            headerText : "<spring:message code='service.title.Remark'/>",
            editable : false,
            width : 400
          },
          {
            dataField : "crtDt",
            headerText : "<spring:message code='service.grid.CrtDt'/>",
            editable : false,
            width : 100,
            dataType : "date",
            formatString : "dd/mm/yyyy"
          },
          {
            dataField : "crtBy",
            headerText : "<spring:message code='service.grid.CrtBy'/>",
            editable : false,
            width : 100,
            dataType : "date",
            formatString : "dd/mm/yyyy"
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

      myGridIDPop = AUIGrid.create("#grid_wrap_srvItmStkCntList", columnLayout, gridPros);
  }


  function srvItmMgmtAddGrid() {
      var columnLayoutAdd = [
          {
            dataField : "trxDt",
            headerText : "<spring:message code='service.grid.trxDt'/>",
            editable : false,
            width : 100
          },
          {
            dataField : "movTypCde",
            headerText : "<spring:message code='service.grid.mov'/>",
            editable : false,
            width : 100,
            visible : false
          },
          {
            dataField : "movTyp",
            headerText : "<spring:message code='service.grid.mov'/>",
            editable : false,
            width : 100
          },
          {
            dataField : "movDtlCde",
            headerText : "<spring:message code='service.grid.mov'/>",
            editable : false,
            width : 100,
            visible : false
          },
          {
            dataField : "movDtl",
            headerText : "<spring:message code='service.grid.movDtl'/>",
            editable : false,
            width : 400
          },
          {
            dataField : "qty",
            headerText : "<spring:message code='service.grid.Quantity'/>",
            editable : false,
            width : 100
          },
          {
            dataField : "rmk",
            headerText : "<spring:message code='service.title.Remark'/>",
            editable : false,
            width : 400
          }
      ];

      var gridProsAdd = {
        showRowCheckColumn : false,
        softRemoveRowMode : false,
        usePaging : true,
        pageRowCount : 20,
        showRowAllCheckBox : false,
        editable : false,
        selectionMode : "multipleCells"
      };

      myGridIDPopAdd = AUIGrid.create("#srvItmAdd_grid_wrap", columnLayoutAdd, gridProsAdd);

      AUIGrid.bind(myGridIDPopAdd, "cellClick", function( event ) {
        deleteRowIdx = event.rowIndex;
      });
  }

  function getSrvItm() {
    Common.ajax("GET", "/services/sim/getSrvItmRcd.do", $("#srvItmPreForm").serialize(), function(result) {
        console.log(result);
        AUIGrid.setGridData(myGridIDPop, result);

        AUIGrid.setProp(myGridIDPop, "rowStyleFunction", function(rowIndex, item) {
            if(item.movTypCde == 1) {
              return "my-pink-style";
            }
         });

         AUIGrid.update(myGridIDPop);
      });
  }

  function fn_excelDown() {
    GridCommon.exportTo("grid_wrap_srvItmStkCntList", "xlsx", "Service Item Management");
  }

  function fn_refresh(allRowItems) {
    getSrvItm();

    if (allRowItems.length > 0) {
      for (var i = allRowItems.length + 1; i > 0; i--) {
        AUIGrid.removeRow(myGridIDPopAdd, 0);
      }
    }
  }
</script>

<div id="popup_wrap" class="popup_wrap">

 <section id="content">

  <form id="srvItmPreForm" method="post">
   <div style="display: none">
    <input type="text" name="BR_TYP" id="BR_TYP" value="${BR_TYP}" />
    <input type="text" name="BR" id="BR" value="${BR}" />
    <input type="text" name="ITM_CDE" id="ITM_CDE" value="${ITM_CDE}" />
   </div>
  </form>

  <header class="pop_header">
   <h1><spring:message code='service.title.srvItmMgmt'/> - <spring:message code='sys.btn.view'/></h1>
   <ul class="right_opt">
    <li><p class="btn_blue2">
      <a href="#"><spring:message code='sys.btn.close'/></a>
     </p></li>
   </ul>
  </header>

  <section class="pop_body">
    <section class="search_table">
      <form action="#" method="post" id="srvItmEntryForm" onsubmit="return false;">
        <table class="type1">
        <caption>table</caption>
        <colgroup>
          <col style="width: 150px" />
          <col style="width: 150px" />
          <col style="width: 150px" />
          <col style="width: 150px" />
        </colgroup>
        <tbody>
         <tr>
          <th scope="row"><spring:message code='service.grid.brchTyp'/></th>
          <td><span id='txtBrchTyp'>${BR_TYP_DESC}</span></td>
          <th scope="row"><spring:message code='service.grid.bch'/></th>
          <td><span id='txtBrch'></span>${BR_DESC}</td>
         </tr>
         <tr>
           <th scope="row"><spring:message code='service.grid.itmCde'/></th>
           <td><span id='txtItmCde'></span>${ITM_STK_CDE}</td>
           <th scope="row"><spring:message code='service.grid.itmDesc'/></th>
           <td><span id='txtItmDesc'>${ITM_STK_DESC}</span></td>
         </tr>
      </tbody>
     </table>
     <!-- table end -->
    </form>
   </section>

  <table>
   <tr>
    <td>
      <h1><spring:message code='service.title.movTrxDtl'/></h1> <span style="color:red"><spring:message code='service.title.row500Dt'/></span>
    </td>
    <td>
     <p class="btn_grid" align="right">
      <a href="#" onClick="fn_excelDown()"><spring:message code='service.btn.Generate'/></a>
     </p>
     </td>
   </tr>
   </table>

   <article class="grid_wrap">
     <div id="grid_wrap_srvItmStkCntList" style="width: 100%; height: 250px; margin: 0 auto;"></div>
   </article>

  </section>
  <!-- content end -->
 </section>
 <!-- content end -->
</div>
<!-- popup_wrap end -->
<script>
</script>