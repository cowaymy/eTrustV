<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>

<!--
 DATE        BY     VERSION        REMARK
 ----------------------------------------------------------------
 27/06/2019  ONGHC  1.0.0          CREATE FOR SERVICE ITEM MANEGEMENT
 06/08/2019  ONGHC  1.0.1          ADD CHECKING USER BRANCH VS RECORD BRANCH
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
      srvItmMgmtAddGrid();
      getSrvItm(); // GET RECORD FOR GRID

      doGetCombo('/services/sim/getMovTyp.do', '', '', 'cboMovTyp', 'S', ''); // ITEM TYPE
      // SET TRIGGER FUNCTION HERE --
      $("#cboMovTyp").change(function() {
        var ind;
        if ($("#cboMovTyp").val() == 0) {
          ind = '420';
        } else if ($("#cboMovTyp").val() == 1) {
          ind = '421';
        }
        doGetCombo('/services/sim/getMovDtl.do', ind, '', 'cboMovDtl', 'S', '');
      });

      doGetCombo("/logistics/codystock/selectCMGroupList.do", '${BR}', '', 'cmgroup', 'S', '');

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
        AUIGrid.setGridData(myGridIDPop, result);

        AUIGrid.setProp(myGridIDPop, "rowStyleFunction", function(rowIndex, item) {
            if(item.movTypCde == 1) {
              return "my-pink-style";
            }
         });

         AUIGrid.update(myGridIDPop);
      });
  }

  function fn_Add() {
    // VERIFY MANDATORY
    var trxDt = $("#txtTrxDt").val();
    var movTyp = $("#cboMovTyp").val();
    var movDtl = $("#cboMovDtl").val();
    var qty = $("#txtQty").val();
    var rmk = $("#txtRmk").val();

    var msg = "";
    var lbl = "";

    if (trxDt == "" || trxDt == null) {
      lbl = "<spring:message code='service.grid.trxDt'/>";
      msg += "* <spring:message code='sys.msg.necessary' arguments='" + lbl + "' htmlEscape='false'/> <br/>";
    }
    if (movTyp == "" || movTyp == null) {
      lbl = "<spring:message code='service.grid.mov'/>";
      msg += "* <spring:message code='sys.msg.necessary' arguments='" + lbl + "' htmlEscape='false'/> <br/>";
    }
    if (movDtl == "" || movDtl == null) {
      lbl = "<spring:message code='service.grid.movDtl'/>";
      msg += "* <spring:message code='sys.msg.necessary' arguments='" + lbl + "' htmlEscape='false'/> <br/>";
    }
    if (qty == "" || qty == null) {
      lbl = "<spring:message code='service.grid.Quantity'/>";
      msg += "* <spring:message code='sys.msg.necessary' arguments='" + lbl + "' htmlEscape='false'/> <br/>";
    }

    if (msg != "") {
      Common.alert(msg);
      return;
    }

    // START ADD
    var itm = new Object();

    itm.trxDt = trxDt;
    itm.movTypCde = movTyp;
    itm.movTyp = $("#cboMovTyp option:selected").text();
    itm.movDtlCde = movDtl;
    itm.movDtl = $("#cboMovDtl option:selected").text();
    itm.qty = qty;
    itm.rmk = rmk;

    AUIGrid.addRow(myGridIDPopAdd, itm, "first");
    fn_resetInput();
  }

  function fn_Delete() {
    if (deleteRowIdx < 0) {
      Common.alert("<spring:message code='service.msg.selectRcd'/>");
      return;
    }
    AUIGrid.removeRow(myGridIDPopAdd, deleteRowIdx);
    deleteRowIdx = -1;
  }

  function fn_resetInput() {
    $("#txtTrxDt").val("");
    $("#cboMovTyp").val("");
    $("#cboMovDtl").val("");
    // RESET CBO
    doGetCombo('/services/sim/getMovDtl.do', '', '', 'cboMovDtl', 'S', '');
    $("#txtQty").val("");
    $("#txtRmk").val("");
  }

  function fn_doSave() {
    if ("${BR}" != '${SESSION_INFO.userBranchId}') {
      Common.confirm("<spring:message code='service.msg.simBchChk'/>", fn_doSaveCont);
    } else {
      fn_doSaveCont();
    }
  }

  function fn_doSaveCont() {
    var allRowItems = AUIGrid.getGridData(myGridIDPopAdd);

    console.log(allRowItems);

    var resultMst = { BR_TYP : $("#BR_TYP").val(),
                      BR : $("#BR").val(),
                      ITM_CDE : $("#ITM_CDE").val(),
                      MEM_ID : $("#member").val(),
                      refDocNo : $("#txtDocNo").val(),
                      deptCode : $("#cmgroup").val()
                    }
    var saveForm = { "allRowItems" : allRowItems,
                     "resultMst" : resultMst
                   }

    if (allRowItems.length == 0) {
      Common.alert("<spring:message code='service.msg.addRcdBfSave'/>");
      return;
    }

    Common.ajax("POST", "/services/sim/srvItmSave.do", saveForm,
      function(result) {
        console.log(result);
        if (result.code == "00") {
          var msg = "<spring:message code='service.title.srvItmSucc'/> <br/>";
          msg += "<spring:message code='service.title.movIn'/> : " + result.data.inQty + "<br/>";
          msg += "<spring:message code='service.title.movOut'/> : " + result.data.outQty + "<br/>";
          msg += "<spring:message code='commission.text.search.totalItem'/> : " + result.data.gtQty;
          Common.alert(msg);
          fn_refresh(allRowItems);
       }
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

  function fn_ChangeCMGroup() {
      CommonCombo.make('member', '/logistics/codystock/getCodyCodeList', {
          memLvl : 4,
          memType : 2,
          upperLineMemberID : $("#cmgroup").val()
      }, '');

  }

  function fn_checkQty(){
    let movTyp   = $("#cboMovTyp").val();
    let balance  = parseInt("${QTY}");
    let quantity = $("#txtQty").val() != '' ? parseInt($("#txtQty").val()) : 0;

    if(movTyp == '0'){
        balance = balance + quantity;
        $('#txtBal').val(balance);

    }else if(movTyp == '1'){
        balance = balance - quantity;

        if( (balance) < 0){
            $("#txtQty").val("0");
            $('#txtBal').val("${QTY}");
            Common.alert("Quantity cannot be lesser than balance");
        }else{
            $('#txtBal').val(balance);
        }
    }else{
        $("#txtQty").val("0");
        $('#txtBal').val("${QTY}");

    }

  }

  $(function(){
      $('#cboMovTyp').change(function(){
          fn_checkQty();
      });
  });
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
   <h1><spring:message code='service.title.srvItmMgmt'/> - <spring:message code='sys.btn.add'/></h1>
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

   <h1><spring:message code='service.title.General'/></h1><br/>

   <section class="search_table">
    <!-- search_table start -->
    <form action="#" method="post" id="" onsubmit="return false;">
     <table class="type1">
     <!-- table start -->
     <caption>table</caption>
     <colgroup>
      <col style="width: 170px" />
      <col style="width: *" />
      <col style="width: 170px" />
      <col style="width: *" />
     </colgroup>
     <tbody>
      <tr>
       <th scope="row"><spring:message code='service.grid.trxDt'/><span class='must'> *</span></th>
       <td>
         <input type="text" title="<spring:message code='service.grid.trxDt'/>" placeholder="DD/MM/YYYY" class="j_date" id="txtTrxDt" name="txtTrxDt" />
       </td>
       <th scope="row"></th>
       <td></td>
      </tr>
      <tr>
       <th scope="row"><spring:message code='service.grid.mov'/><span class='must'> *</span></th>
       <td>
         <select id="cboMovTyp" name="cboMovTyp" class="w100p" />
       </td>
       <th scope="row"><spring:message code='service.grid.movDtl'/><span class='must'> *</span></th>
       <td>
         <select id="cboMovDtl" name="cboMovDtl" class="w100p">
           <option value=""><spring:message code='sal.combo.text.chooseOne'/></option>
         </select>
       </td>
      </tr>
      <tr>
       <th scope="row"><spring:message code='log.title.text.cmGroup'/></th>
       <td>
           <select class="w100p" id="cmgroup" onchange="fn_ChangeCMGroup()"></select>
       </td>
       <th scope="row"><spring:message code='sal.title.memberCode'/></th>
       <td>
           <select class="w100p" id="member" name="member"></select>
       </td>
      </tr>
      <tr>
       <th scope="row"><spring:message code='log.title.text.invStkBal'/></th>
       <td>
         <input type="text" id="txtBal" name="txtBal" class="disabled w100p" disabled value="${QTY}"/>
       </td>
       <th scope="row"><spring:message code='service.grid.Quantity'/><span class='must'> *</span></th>
       <td>
         <input type="text" placeholder="<spring:message code='service.grid.Quantity'/>" id="txtQty" name="txtQty" class="w100p" onblur="fn_checkQty()" onkeyup="if (/\D/g.test(this.value)) this.value = this.value.replace(/\D/g,'')"/>
       </td>
      </tr>
      <tr>
       <th scope="row"><spring:message code='log.head.refdocno'/></th>
       <td colspan="3"><input type="text" id="txtDocNo" name="txtDocNo" class="w100p"/></td>
      </tr>
      <tr>
       <th scope="row"><spring:message code='service.title.Remark'/></th>
       <td colspan="3"><textarea cols="20" rows="5" placeholder="<spring:message code='service.title.Remark'/>" id='txtRmk' name='txtRmk'></textarea></td>
      </tr>
     </tbody>
    </table>

    <ul class="center_btns" id='addDiv'>
     <li><p class="btn_blue2">
       <a href="#" onclick="fn_Add()"><spring:message code='sys.btn.add'/></a>
      </p></li>
     <li><p class="btn_blue2">
       <a href="#" onclick="fn_Delete()"><spring:message code='sys.btn.delete'/></a>
      </p></li>
    </ul>
    <article class="grid_wrap">
     <!-- grid_wrap start -->
     <div id="srvItmAdd_grid_wrap"
      style="width: 100%; height: 220px; margin: 0 auto;"></div>
    </article>
     <!-- table end -->
    </form>
   </section>

   <ul class="center_btns mt20">
    <li><p class="btn_blue2 big">
      <a href="#" onclick="fn_doSave()"><spring:message code='sys.btn.save'/></a>
     </p></li>
   </ul>
  </section>
  <!-- content end -->
 </section>
 <!-- content end -->
</div>
<!-- popup_wrap end -->
<script>
</script>