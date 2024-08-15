<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>

<script type="text/javascript">
  var supSofGridID;
  createAUIGrid();

  function fn_multiComboBranch() {
    if ($("#cmbKeyBranch option[value='${ind}']").val() === undefined) {
      $("#cmbKeyBranch").prop('disabled', false);
    } else {
      if ('${auth}' == "Y") {
        $("#cmbKeyBranch").val('${ind}');
        $("#cmbKeyBranch").prop('disabled', false);
      } else {
        $("#cmbKeyBranch").val('${ind}');
        $("#cmbKeyBranch").prop('disabled', true);
      }
    }
  }

  function validRequiredField(){
    var valid = true;
    var message = "";

    var sDate = $('#dpOrderDateFr').val();
    var eDate = $('#dpOrderDateTo').val();

    var dd = "";
    var mm = "";
    var yyyy = "";

    var dateArr;
    dateArr = sDate.split("/");
    var sDt = new Date(Number(dateArr[2]), Number(dateArr[1]) - 1, Number(dateArr[0]));

    dateArr = eDate.split("/");
    var eDt = new Date(Number(dateArr[2]), Number(dateArr[1]) - 1, Number(dateArr[0]));

    var dtDiff = new Date(eDt - sDt);
    var days = dtDiff / 1000 / 60 / 60 / 24;

    if (days > 31) {
      var label = "<spring:message code='sal.text.ordDate' />";
      Common.alert("<spring:message code='service.msg.asSearchDtRange' arguments='" + label + " ; <b>" + 31 +"</b>' htmlEscape='false' argumentSeparator=';' />");
      return false;
    }

    if (($("#dpOrderDateFr").val() == null || $("#dpOrderDateFr").val().length == 0) || ($("#dpOrderDateTo").val() == null || $("#dpOrderDateTo").val().length == 0)){
      valid = false;
      message += '<spring:message code="sal.alert.msg.keyInOrdDateFromTo" />';
    }

    if(!($("#txtOrderNoFr").val().trim() == null || $("#txtOrderNoFr").val().trim().length == 0) || !($("#txtOrderNoTo").val().trim() == null || $("#txtOrderNoTo").val().trim().length == 0)){
      if(($("#txtOrderNoFr").val().trim() == null || $("#txtOrderNoFr").val().trim().length == 0) || ($("#txtOrderNoTo").val().trim() == null || $("#txtOrderNoTo").val().trim().length == 0)){
        valid = false;
        message += '<spring:message code="sal.alert.msg.keyInOrdNoFromTo" />';
      }
    }

    if(valid == false){
      alert(message);
    }

    return valid;
  }

  function fn_search() {
    if (validRequiredField()) {
      var params = {};

      params["dpOrderDateFr"] =$("#dpOrderDateFr").val();
      params["dpOrderDateTo"] =$("#dpOrderDateTo").val();
      params["txtOrderNoFr"] =$("#txtOrderNoFr").val().replace(/[^0-9]/g, '');
      params["txtOrderNoTo"] =$("#txtOrderNoTo").val().replace(/[^0-9]/g, '');
      params["txtCustName"] =$("#txtCustName").val();
      params["cmbKeyBranch"] =$("#cmbKeyBranch").val();
      params["keyInUser"] =$("#txtUserName").val();
      params["cmbSort"] =$("#cmbSort").val();

      Common.ajax("GET", "/supplement/getSofListingInfo.do", params, function(result) {
        AUIGrid.setGridData(supSofGridID, result);
      });
    }
  }

  function createAUIGrid() {
    var sofColumnLayout = [
    {
      dataField : "supRefCrtDt",
      headerText : '<spring:message code="sal.text.createDate" />',
      width : '20%',
      editable : false
    }, {
      dataField : "supRefNo",
      headerText : '<spring:message code="supplement.text.supplementReferenceNo" />',
      width : '20%',
      editable : false
    }, {
      dataField : "sofNo",
      headerText : '<spring:message code="supplement.text.eSOFno" />',
      width : '15%',
      editable : false
    }, {
      dataField : "br",
      headerText : '<spring:message code="sales.keyInBranch" />',
      width : '15%',
      editable : false
    }, {
      dataField : "custName",
      headerText : '<spring:message code="sal.text.custName" />',
      width : '20%',
      style : 'left_style',
      editable : false
    }, {
      dataField : "salesmanId",
      headerText : '<spring:message code="sal.text.salManCode" />',
      width : '15%',
      editable : false
    }, {
      dataField : "salesmanName",
      headerText : '<spring:message code="sal.text.salManName" />',
      width : '20%',
      style : 'left_style',
      editable : false
    }, {
      dataField : "supRefItm",
      headerText : '<spring:message code="sal.text.productItem" />',
      width : '35%',
      editable : false
    }, {
      dataField : "refCreateBy",
      headerText : '<spring:message code="sal.text.createBy" />',
      width : '10%',
      editable : false
    }, {
      dataField : "isCompany",
      headerText :  '<spring:message code="sal.title.custType" />',
      width : '15%',
      editable : false
    }];

    var gridPros = {
      showRowAllCheckBox : false,
      usePaging : true,
      pageRowCount : 10,
      headerHeight : 30,
      showRowNumColumn : true,
      showRowCheckColumn : false,
    };

    supSofGridID = GridCommon.createAUIGrid("#sofList_grid", sofColumnLayout, '', gridPros);
  }

  function excelDown() {
    const today = new Date();
    const day = String(today.getDate()).padStart(2, '0');
    const month = String(today.getMonth() + 1).padStart(2, '0');
    const year = today.getFullYear();

    const date = year + month + day;
    GridCommon.exportTo("sofList_grid", "xlsx", "FSO_Listing_Xlsx_" + date);
  }

  function pdfDown() {
	console.log("Click Generate PDF START");
    const today = new Date();
    const day = String(today.getDate()).padStart(2, '0');
    const month = String(today.getMonth() + 1).padStart(2, '0');
    const year = today.getFullYear();

    const date = year + month + day;

    if(validRequiredField() == true){
        $("#reportFileName").val("");
        $("#reportDownFileName").val("");
        $("#viewType").val("");

        var orderNoFrom = "";
        var orderNoTo = "";
        var orderDateFrom = "";
        var orderDateTo = "";
        var keyInUser = "";
        var keyInBranch = "";
        var sortBy = "";
        var whereSQL = "";
        var extraWhereSQL = "";
        var orderBySQL = "";
        var custName = "";
        var runNo = 0;
        var txtOrderNoFr = $("#txtOrderNoFr").val().trim();
        var txtOrderNoTo = $("#txtOrderNoTo").val().trim();

        if(!($("#dpOrderDateFr").val() == null || $("#dpOrderDateFr").val().length == 0) && !($("#dpOrderDateTo").val() == null || $("#dpOrderDateTo").val().length == 0)){

            orderDateFrom = $("#dpOrderDateFr").val(); //dd/MM/yyyy
            orderDateTo = $("#dpOrderDateTo").val();

            var frArr = $("#dpOrderDateFr").val().split("/");
            var toArr = $("#dpOrderDateTo").val().split("/");
            var dpOrderDateFr = frArr[0]+"/"+frArr[1]+"/"+frArr[2]; // MM/dd/yyyy
            var dpOrderDateTo = toArr[0]+"/"+toArr[1]+"/"+toArr[2];

            whereSQL += " AND (A.CRT_DT BETWEEN TO_DATE('"+dpOrderDateFr+" 00:00:00', 'DD/MM/YYYY HH24:MI:SS') AND TO_DATE('"+dpOrderDateTo+" 23:59:59', 'DD/MM/YYYY HH24:MI:SS'))";
        }

        runNo = 0;

        if(!(txtOrderNoFr == null || txtOrderNoFr.length == 0) && !(txtOrderNoTo == null || txtOrderNoTo.length == 0)){
            orderNoFrom = txtOrderNoFr;
            orderNoTo = txtOrderNoTo;
            whereSQL += " AND (REGEXP_REPLACE(A.SUP_REF_NO, '[^0-9]', '') BETWEEN TO_CHAR('"+txtOrderNoFr+"') AND TO_CHAR('"+txtOrderNoTo+"'))";
        }

        if($("#cmbKeyBranch :selected").index() > 0){
            keyInBranch = $("#cmbKeyBranch :selected").text();
            whereSQL += " AND A.MEM_BRNCH_ID = '"+$("#cmbKeyBranch :selected").val()+"'";
        }

        if(!($("#txtCustName").val().trim() == null || $("#txtCustName").val().trim().length == 0)){
            custName = $("#txtCustName").val().trim();
            whereSQL += " AND C.NAME LIKE '%"+custName.replace("'", "''")+"%' ";
        }

        if(!($("#txtUserName").val().trim() == null || $("#txtUserName").val().trim().length == 0)){
        	keyInUser = $("#txtUserName").val().trim();
            whereSQL += " AND G.USER_NAME LIKE '%"+keyInUser.replace("'", "''")+"%' ";
        }

        if($("#cmbSort :selected").index() > -1){
            sortBy = $("#cmbSort :selected").text();

            if($("#cmbSort :selected").val() == "2"){
                orderBySQL = " ORDER BY A.MEM_BRNCH_ID";
            }else if($("#cmbSort :selected").val() == "3"){
                orderBySQL = " ORDER BY A.CRT_DT";
            }else if($("#cmbSort :selected").val() == "4"){
                orderBySQL = " ORDER BY A.SUP_REF_NO";
            }else if($("#cmbSort :selected").val() == "5"){
                orderBySQL = " ORDER BY C.NAME";
            }
        }

        $("#reportDownFileName").val("FSO_Listing_Pdf_"+date+(new Date().getMonth()+1)+new Date().getFullYear());
        $("#searchForm2 #viewType").val("PDF");
        $("#searchForm2 #reportFileName").val("/supplement/SupplementOrderSOFList.rpt");
        $("#searchForm2 #V_ORDERNOFROM").val(orderNoFrom);
        $("#searchForm2 #V_ORDERNOTO").val(orderNoTo);
        $("#searchForm2 #V_ORDERDATEFROM").val(orderDateFrom);
        $("#searchForm2 #V_ORDERDATETO").val(orderDateTo);
        $("#searchForm2 #V_KEYINBRANCH").val(keyInBranch);
        $("#searchForm2 #V_KEYINUSER").val(keyInUser);
        $("#searchForm2 #V_CUSTNAME").val(custName);
        $("#searchForm2 #V_SORTBY").val(sortBy);
        $("#searchForm2 #V_WHERESQL").val(whereSQL);
        $("#searchForm2 #V_EXTRAWHERESQL").val(extraWhereSQL);
        $("#searchForm2 #V_ORDERBYSQL").val(orderBySQL);
        $("#searchForm2 #V_SELECTSQL").val("");
        $("#searchForm2 #V_FULLSQL").val("");

        var option ={
        		isProcedure :true
        };

        Common.report("searchForm2", option);
        console.log("Click Generate PDF END");
        console.log("Report Download File Name :: " + $("#reportDownFileName").val());
        console.log("Report template File Name :: " + $("#reportFileName").val());
    }else {
    	return false;
    }
  }

  CommonCombo.make('cmbKeyBranch', '/sales/ccp/getBranchCodeList', '' , '', '', fn_multiComboBranch);
</script>

<div id="popup_wrap" class="popup_wrap">
  <header class="pop_header">
    <h1><spring:message code="sal.title.text.ordReportSalesOrdFromSofList" /></h1>
    <ul class="right_opt">
      <li><p class="btn_blue2"><a href="#" onclick="javascript:fn_search();"><spring:message code="sales.btn.search" /></a></p></li>
      <li><p class="btn_blue2"><a href="#"><spring:message code="sal.btn.close" /></a></p></li>
    </ul>
  </header>

  <section class="pop_body">
    <aside class="title_line"></aside>
  <section class="search_table">
  <form id="searchForm2">
    <input type="hidden" id="reportFileName" name="reportFileName" value="" />
    <input type="hidden" id="viewType" name="viewType" value="" />
    <input type="hidden" id="reportDownFileName" name="reportDownFileName" value="" />
    <input type="hidden" id="V_ORDERNOFROM" name="V_ORDERNOFROM" value="" />
    <input type="hidden" id="V_ORDERNOTO" name="V_ORDERNOTO" value="" />
    <input type="hidden" id="V_ORDERDATEFROM" name="V_ORDERDATEFROM" value="" />
    <input type="hidden" id="V_ORDERDATETO" name="V_ORDERDATETO" value="" />
    <input type="hidden" id="V_KEYINBRANCH" name="V_KEYINBRANCH" value="" />
    <input type="hidden" id="V_CUSTNAME" name="V_CUSTNAME" value="" />
    <input type="hidden" id="V_KEYINUSER" name="V_KEYINUSER" value="" />
    <input type="hidden" id="V_SORTBY" name="V_SORTBY" value="" />
    <input type="hidden" id="V_WHERESQL" name="V_WHERESQL" value="" />
    <input type="hidden" id="V_EXTRAWHERESQL" name="V_EXTRAWHERESQL" value="" />
    <input type="hidden" id="V_ORDERBYSQL" name="V_ORDERBYSQL" value="" />
    <input type="hidden" id="V_SELECTSQL" name="V_SELECTSQL" value="" />
    <input type="hidden" id="V_FULLSQL" name="V_FULLSQL" value="" />
    <table class="type1">
      <caption>table</caption>
      <colgroup>
        <col style="width:180px" />
        <col style="width:*" />
        <col style="width:180px" />
        <col style="width:*" />
      </colgroup>
      <tbody>
        <tr>
          <th scope="row"><spring:message code="sal.text.ordDate" /></th>
          <td>
            <div class="date_set w100p">
              <p><input type="text" title="Create start Date" placeholder="DD/MM/YYYY" class="j_date" id="dpOrderDateFr" value="${bfDay}"/></p>
              <span><spring:message code="sal.title.to" /></span>
              <p><input type="text" title="Create end Date" placeholder="DD/MM/YYYY" class="j_date" id="dpOrderDateTo" value="${toDay}"/></p>
            </div>
          </td>
          <th scope="row"><spring:message code="sal.text.ordNum" /></th>
          <td>
            <div class="date_set w100p">
              <p><input type="text" title="" placeholder="" class="w100p" id="txtOrderNoFr"/></p>
              <span><spring:message code="sal.title.to" /></span>
              <p><input type="text" title="" placeholder="" class="w100p" id="txtOrderNoTo"/></p>
            </div>
          </td>
        </tr>
        <tr>
          <th scope="row"><spring:message code="sal.text.custName" /></th>
          <td colspan="3"><input type="text" title="" placeholder="" class="w100p" id="txtCustName"/></td>
        </tr>
        <tr>
           <th scope="row"><spring:message code="sal.text.keyInBranch" /></th>
          <td>
            <select class="w100p" id="cmbKeyBranch"></select>
          </td>
          <th scope="row"><spring:message code="sal.text.keyInUser" /></th>
          <td>
            <input type="text" title="" placeholder="" class="w100p" id="txtUserName"/>
          </td>
        </tr>
        <tr>
          <th scope="row"><spring:message code="sal.title.text.sorting" /></th>
          <td>
            <select class="w100p" id="cmbSort">
              <!-- <option value="1">By Region</option> -->
              <option value=""><spring:message code="sal.combo.text.chooseOne" /></option>
              <option value="2"><spring:message code="sal.combo.text.byBrnch" /></option>
              <option value="3"><spring:message code="sal.combo.text.byOrdDt" /></option>
              <option value="4" selected><spring:message code="sal.combo.text.byOrdNumber" /></option>
              <option value="5"><spring:message code="sal.combo.text.byCustName" /></option>
            </select>
          </td>
          <th scope="row"></th>
          <td></td>
        </tr>
      </tbody>
    </table>

    <section class="search_result">
      <ul class="right_btns">
        <li>
          <p class="btn_grid">
            <!--<a href="#" id="pdfDown" onclick="pdfDown()"><spring:message code="sal.btn.genPDF" /></a>  -->
            <a href="#" onclick="javascript:pdfDown();"><spring:message code="sal.btn.genPDF" /></a>
          </p>
        </li>
        <li>
          <p class="btn_grid">
            <a href="#" id="excelDown" onclick="excelDown()"><spring:message code="sal.btn.genExcel" /></a>
          </p>
        </li>
      </ul>
      <aside class="title_line">
      </aside>
      <article class="grid_wrap">
        <div id="sofList_grid" style="width: 100%; height: 340px; margin: 0 auto;"></div>
      </article>
    </section>
  </form>
  </section>
  </section>
</div>