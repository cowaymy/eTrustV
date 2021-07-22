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

  var seqNo,crtDt,currentDt,crtDtString,currentDtString,movTypCde,movDtlCde,deptCode,memId,bal,qty;

  $(document).ready(
    function() {
      srvItmMgmtGrid(); // CREATE GRID
      getSrvItm(); // GET RECORD FOR GRID

      // Double click grid item to edit
      AUIGrid.bind(myGridIDPop, "cellDoubleClick", function(event) {

      Common.ajaxSync("GET", "/services/sim/searchSrvItmLst.do", {cboBch : '${BR}', cboItm : '${ITM_CDE}'}, function(result) {
        bal = parseInt(result[0].qty);
      });

          crtDt = new Date(AUIGrid.getCellValue(myGridIDPop, event.rowIndex, "crtDt"));
          currentDt = new Date();
          crtDtString = crtDt.getFullYear().toString()  + crtDt.getMonth().toString();
          currentDtString = currentDt.getFullYear().toString()  + currentDt.getMonth().toString();

          movTypCde = AUIGrid.getCellValue(myGridIDPop, event.rowIndex, "movTypCde");
          movDtlCde = AUIGrid.getCellValue(myGridIDPop, event.rowIndex, "movDtlCde");

          deptCode = AUIGrid.getCellValue(myGridIDPop, event.rowIndex, "deptCode");
          qty = parseInt(AUIGrid.getCellValue(myGridIDPop, event.rowIndex, "qty"))
          memId = '';

          if(AUIGrid.getCellValue(myGridIDPop, event.rowIndex, "memId") != undefined)
        	  memId = AUIGrid.getCellValue(myGridIDPop, event.rowIndex, "memId").toString();

	      $('#txtTrxDt').val(AUIGrid.getCellValue(myGridIDPop, event.rowIndex, "trxDt"));
	      $('#txtDocNo').val(AUIGrid.getCellValue(myGridIDPop, event.rowIndex, "refNo"));
	      $("#txtBal").val(bal);
	      $('#txtQty').val(qty);
	      $('#txtRmk').val(AUIGrid.getCellValue(myGridIDPop, event.rowIndex, "rmk"));

	      seqNo = AUIGrid.getCellValue(myGridIDPop, event.rowIndex, "seqNo");

	      fn_validEdit();
      });
    });

  function srvItmMgmtGrid() {
      var columnLayout = [
          {
            dataField : "seqNo",
            headerText : "seqNo",
            editable : false,
            width : 100,
            visible : false
          },
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
            dataField : "memCode",
            headerText : "<spring:message code='sal.title.memberCode'/>",
            editable : false,
            width : 100
          },
          {
            dataField : "refNo",
            headerText : "<spring:message code='log.head.refdocno'/>",
            editable : false,
            width : 200
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
          },
          {
              dataField : "crtBy",
              visible : false,
              width : 100,
              dataType : "date",
              formatString : "dd/mm/yyyy"
          },
          {
              dataField : "movDtlCde",
              visible : false
          },
          {
              dataField : "deptCode",
              visible : false
          },
          {
              dataField : "memId",
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
        //console.log(result);
        AUIGrid.setGridData(myGridIDPop, result);

        AUIGrid.setProp(myGridIDPop, "rowStyleFunction", function(rowIndex, item) {
            if(item.movTypCde == 1 || item.movTypCde == 3) {
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
    $("#edit_grid").hide();

    /* if (allRowItems.length > 0) {
      for (var i = allRowItems.length + 1; i > 0; i--) {
        AUIGrid.removeRow(myGridIDPopAdd, 0);
      }
    } */
  }

  function fn_validEdit(){

	  let ind = 0;
      switch(movTypCde) {
      case 0:
        ind = 420;
        break;
      case 1:
        ind = 421;
        break;
      default:
        ind = 0
        break;
      }

      if(currentDtString <= crtDtString){
         if(movTypCde == 0 || movTypCde == 1){

          doGetCombo('/services/sim/getMovTyp.do', '', movTypCde, 'cboMovTyp', 'S', ''); // ITEM TYPE
          doGetCombo('/services/sim/getMovDtl.do', ind, movDtlCde, 'cboMovDtl', 'S', '');
          doGetCombo("/logistics/codystock/selectCMGroupList.do", '${BR}', deptCode, 'cmgroup', 'S', '');
          CommonCombo.make('member', '/logistics/codystock/getCodyCodeList'
                  , {memLvl : 4,memType : 2,upperLineMemberID : deptCode}
                  , memId);

          $("#edit_grid").show();
        }else{
            Common.alert("Not allowed to edit for this movement type");
            $("#edit_grid").hide();
        }

      }else{
          $("#edit_grid").hide();
          Common.alert("<spring:message code='service.msg.passMnthDisallowEdit'/>");
      }
  }

  function fn_checkQty(){
	  let movTyp   = $("#cboMovTyp").val();
	  let balance  = bal;
	  let quantity = $("#txtQty").val() != '' ? parseInt($("#txtQty").val()) : 0;

	  if(movTyp == '0'){
	      balance = balance + (quantity-qty);
	      $('#txtBal').val(balance);

	  }else if(movTyp == '1'){
	      balance = balance - (quantity != qty ? quantity : 0);

	      if( (balance) < 0){
	          $("#txtQty").val("0");
	          $('#txtBal').val(bal);
	          Common.alert("Quantity cannot be lesser than balance");
	      }else{
	          $('#txtBal').val(balance);
	      }

	  }else{
	      $("#txtQty").val(qty);
	      $('#txtBal').val(bal);

	  }

	}

  function fn_Edit(){
      Common.confirm("<spring:message code='sys.common.alert.save'/>",
        function(){
        var allRowItems = [];

        allRowItems[0] = {
        		movDtlCde: $("#cboMovDtl").val(),
                movTypCde: $("#cboMovTyp").val(),
                qty: $("#txtQty").val(),
                rmk: $("#txtRmk").val(),
                trxDt: $("#txtTrxDt").val()
        };

          var resultMst = {
                BR_TYP : '${BR_TYP}',
                BR : '${BR}',
                ITM_CDE : '${ITM_CDE}',
                MEM_ID : $("#member").val(),
                refDocNo : $("#txtDocNo").val(),
                deptCode : $("#cmgroup").val(),
                seqNo : seqNo
        };

        var saveForm = {
        	    "allRowItems" : allRowItems,
                "resultMst" : resultMst
        };

    	  console.log(saveForm);
    	  Common.ajax("POST", "/services/sim/editSrvItmRcd.do", saveForm, function(result) {
            console.log(result);
              if(result.code == '00') {
                  Common.alert("Record edited");
                  fn_refresh();
              } else {
                  Common.alert(result.message);
              }
          });
      });
  }

  function fn_Delete(){
	  Common.confirm("<spring:message code='sys.common.alert.delete'/>",
		function(){Common.ajax("GET", "/services/sim/deleteSrvItmRcd.do", {seqNo:seqNo},
		  function(result) {
			console.log(result);
              if(result.code == '00') {
                  Common.alert("Record removed");
                  fn_refresh();
              } else {
                  Common.alert(result.message);
              }
		  });
	  });
  }

  $(function(){
	  $("#cboMovTyp").change(function(e) {
	        var ind;

	        if ($("#cboMovTyp").val() == 0) {
	          ind = '420';
	        } else if ($("#cboMovTyp").val() == 1) {
	          ind = '421';
	        }
	        doGetCombo('/services/sim/getMovDtl.do', ind, '', 'cboMovDtl', 'S', '');

	        fn_checkQty();
	    });
	  $('#cboMovDtl').change(function(){
	         if(
	                 ($('#cboMovTyp').val() == '0' && this.value == '1') || // Movement In - Resigned Cody Return
	                 ($('#cboMovTyp').val() == '1' && this.value == '0') // Movement Out - Consign to Cody
	            ){
	             $('#cmgroup').attr("disabled",false);
	             $('#member').attr("disabled",false);
	         }else{
	             $('#cmgroup').attr("disabled",true);
	             $('#member').attr("disabled",true);
	         }

	  });
	  $("#cmgroup").change(function(e){
		  CommonCombo.make('member', '/logistics/codystock/getCodyCodeList'
	              , {memLvl : 4,memType : 2,upperLineMemberID : $('#cmgroup').val()}
	              , '');
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

   <article id="edit_grid" style="display:none">
   <h1><spring:message code='service.title.General'/></h1><br/>

   <section class="search_table">
   <form action="#" method="post" id="editForm" onsubmit="return false;">
    <!-- search_table start -->
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
           <select class="w100p" id="cmgroup" name="cmgroup" disabled></select>
       </td>
       <th scope="row"><spring:message code='sal.title.memberCode'/></th>
       <td>
           <select class="w100p" id="member" name="member" disabled></select>
       </td>
      </tr>
      <tr>
       <th scope="row"><spring:message code='log.title.text.invStkBal'/></th>
       <td>
         <input type="text" id="txtBal" name="txtBal" class="disabled w100p" disabled/>
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
       <a href="#" onclick="fn_Edit()"><spring:message code='sys.btn.edit'/></a>
      </p></li>
     <li><p class="btn_blue2">
       <a href="#" onclick="fn_Delete()"><spring:message code='sys.btn.delete'/></a>
      </p></li>
    </ul>
     <!-- table end -->
    </form>
   </section>
    </article>

  </section>
  <!-- content end -->
 </section>
 <!-- content end -->
</div>
<!-- popup_wrap end -->
