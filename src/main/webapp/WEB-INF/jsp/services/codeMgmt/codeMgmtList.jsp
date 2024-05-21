<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8" %>
  <%@ include file="/WEB-INF/tiles/view/common.jsp" %>

    <style type="text/css">
      /* 칼럼 스타일 전체 재정의 */
      .aui-grid-left-column {
        text-align: left;
      }

      .write-active-style {
        background: #ddedde;
      }

      .my-inactive-style {
        background: #efcefc;
      }
    </style>
    <script type="text/javaScript">

var businessCatList = new Array();
var svcTypeList = new Array();
var prodCatList = new Array();
var codeCatList = new Array();
var statusList = new Array();
var largeGridID;
var oldRowIndex = -1;

$(document).ready(function(){

    createLargeAUIGrid();
    getBusinessCat();
    getSvcType();
    getProdCat();
    getStatus();

    doGetCombo('/common/selectCodeList.do', '553', '', 'cmbType', 'S','');
    doGetCombo('/common/selectCodeList.do', '500', '', 'cmbBusiCtgry', 'M','f_multiCombo');

    AUIGrid.bind(largeGridID, "cellDoubleClick", function(event) {
        var selectedItems = AUIGrid.getSelectedItems(largeGridID);
        var viewType = 3; //View

        console.log(selectedItems);
        var defectId = selectedItems[0].item.defectId;
        var prodCat = selectedItems[0].item.prodCat == '-' && selectedItems[0].item.prodCat == '*' ? null : selectedItems[0].item.prodCat;
        var codeCatId = selectedItems[0].item.codeCatId;
        var defCode = selectedItems[0].item.defectCode;
        var prodCode = selectedItems[0].item.prodCode;
        var codeCatName = selectedItems[0].item.codeCatName;
        var stkId = selectedItems[0].item.stkId;
        var svcLargeCode = selectedItems[0].item.svcLargeCode == '-' ? null : selectedItems[0].item.svcLargeCode;
        Common.popupDiv("/services/codeMgmt/addEditCodePop.do?isPop=true&defectId=" + defectId + "&viewType=" + viewType + "&defCode=" + defCode
                + "&codeCatId=" + codeCatId + "&codeCatName=" + codeCatName + "&stkId=" + stkId+ "&prodCat=" + prodCat + "&svcLargeCode=" + svcLargeCode
                + "&prodCode=" + prodCode);
    });
});

$(function(){
    $('#cmbType').change(function() {
             doGetCombo('/services/codeMgmt/selectCodeCatList.do', $('#cmbType').val(), '', 'cmbCodeCat', 'M','f_multiCombo');
    });
});

function fn_selectCodeMgmtList()
{
	AUIGrid.refreshRows() ;

	if ($("#prodCode").val() == '' && $("#defName").val() == '' && $("#defCode").val() == '') {
        if ($("#cmbType").val() == null || $("#cmbType").val() == '') {
            Common.alert("<spring:message code='sys.common.alert.validation' arguments='Service Type' htmlEscape='false'/>");
            return false;
        }

        if ($("#cmbCodeCat").val() == null) {
            Common.alert("<spring:message code='sys.common.alert.validation' arguments='Code Category' htmlEscape='false'/>");
            return false;
        }
    }

	Common.ajax("GET", "/services/codeMgmt/selectCodeMgmtList.do", $("#MainForm").serialize() , function(result){
        console.log("성공 data : " + result);
        AUIGrid.setGridData(largeGridID, result);
        oldRowIndex = -1; // 20190911 KR-OHK Initialize Variables
    });
}

function createLargeAUIGrid() {
	var options = {
		 usePaging : true,
		 pageRowCount: 20,
         editable: false,
         fixedColumnCount : 1,
         headerHeight     : 30,
         showRowNumColumn : true
	};

    var MainColumnLayout =
    [
      { dataField : "busiCat", headerText : "business Category", width : "10%"},
      //{ dataField : "svcType", headerText : "Type", width : "10%"},
	  { dataField : "prodCat", headerText : "Product Category", width : "15%"},
	  { dataField : "codeCatId", headerText : "codeCatId", width : "15%",visible: false},
	  { dataField : "codeCatName", headerText : "codeCatName", width : "15%",visible: false},
      { dataField : "codeCat", headerText : "Code Category", width : "15%"},
      { dataField : "defectGrp", headerText : "DefectGrp", width : "15%",visible: false},
      { dataField : "defectGrpCode", headerText : "DefectGrp", width : "15%",visible: false},
      { dataField : "defectId", headerText : "DefectId", width : "15%",visible: false},
      { dataField : "defectTyp", headerText : "defectTyp", width : "15%",visible: false},
      { dataField : "defectCode", headerText : "Defect Code", width : "15%"},
      { dataField : "codeDesc", headerText : "Code Description", width : "15%"},
      { dataField : "codeRemark", headerText : "Code Remark", width : "15%"},
      { dataField : "stusId", headerText : "stusId", width : "15%",visible: false},
      { dataField : "status", headerText : "status", width : "15%"},

      { dataField : "stkId", headerText : "stkId", width : "15%",visible: false},
      { dataField : "prodCode", headerText : "Product Code", width : "15%"},
      { dataField : "prodLaunchDt", headerText : "Product Launch Date", dataType : "date", formatString : "dd-mm-yyyy", width : "15%"},
      { dataField : "ctComm", headerText : "CT Commission", width : "15%"},
      { dataField : "asCost", headerText : "AS Cost", width : "15%"},

      { dataField : "effDt", headerText : "Effect Date", dataType : "date", formatString : "dd-mm-yyyy", width : "15%"},
      { dataField : "expDt", headerText : "Expire Date", dataType : "date", formatString : "dd-mm-yyyy", width : "15%"},
      { dataField : "crtUser", headerText : "Create by", width : "15%"},
      { dataField : "crtDt", headerText : "Create Date", dataType : "date", formatString : "dd-mm-yyyy", width : "15%"},
      { dataField : "updUser", headerText : "Last Update by", width : "15%"},
      { dataField : "updDt", headerText : "Last Update Date", dataType : "date", formatString : "dd-mm-yyyy", width : "15%"}
	];

	largeGridID = GridCommon.createAUIGrid("largeGrid", MainColumnLayout,"", options);
}

function f_multiCombo(){
    $(function() {

        $('#cmbProductCtgry').change(function() {

        }).multipleSelect({
            selectAll: true, // 전체선택
            width: '80%'
        });

        $('#cmbBusiCtgry').change(function() {

        }).multipleSelect({
            selectAll : true,
            width : '80%'
        });

        $('#cmbCodeCat').change(function() {

        }).multipleSelect({
            selectAll : true,
            width : '80%'
        });
    });
}

function fn_clear(){

    $("#cmbProductCtgry").multipleSelect("uncheckAll");
    $("#cmbType").multipleSelect("uncheckAll");
    $("#cmbBusiCtgry").multipleSelect("uncheckAll");
    $("#cmbCodeCat").multipleSelect("uncheckAll");
    $("#codeStatus").multipleSelect("uncheckAll");
    $("#defCode").val("");
    $("#prodCode").val("");
    $("#defName").val("");
}

function getBusinessCat(callBack)
{
      Common.ajaxSync("GET", "/common/selectCodeList.do" , "&groupCode=500" , function(result){

	      businessCatList.push({id:"" ,value:""});
	      for (var i = 0; i < result.length; i++){
	    	    var list = new Object();
	            list.id = result[i].code;
	            list.value = result[i].codeName ;
	            businessCatList.push(list);
	      }

	      if (callBack) {
	       callBack(businessCatList);
	      }

      });

      return businessCatList;
  }

function getSvcType(callBack)
{
      Common.ajaxSync("GET", "/common/selectCodeList.do" , "&groupCode=553" , function(result){

    	  svcTypeList.push({id:"" ,value:""});
          for (var i = 0; i < result.length; i++){
                var list = new Object();
                list.id = result[i].code;
                list.value = result[i].codeName ;
                svcTypeList.push(list);
          }

          if (callBack) {
           callBack(svcTypeList);
          }

      });

      return svcTypeList;
  }

function getProdCat(callBack)
{
      Common.ajaxSync("GET", "/sales/promotion/selectProductCategoryList.do" , "" , function(result){

    	  prodCatList.push({id:"" ,value:""});
          for (var i = 0; i < result.length; i++){
                var list = new Object();
                list.id = result[i].code;
                list.value = result[i].codeName ;
                prodCatList.push(list);
          }

          if (callBack) {
           callBack(prodCatList);
          }

      });

      return prodCatList;
  }

function getStatus(callBack)
{
      Common.ajaxSync("GET", "/common/selectStatusCategoryCodeList.do" , "&selCategoryId=32" , function(result){

    	  statusList.push({id:"" ,value:""});
          for (var i = 0; i < result.length; i++){
                var list = new Object();
                list.id = result[i].code;
                list.value = result[i].codeName ;
                statusList.push(list);
          }

          if (callBack) {
           callBack(statusList);
          }

      });

      return statusList;
  }

function fn_addEditCodePop(viewType) {

	 if(viewType == 1) //NEW
     {
		 Common.popupDiv("/services/codeMgmt/addEditCodePop.do?isPop=true&viewType=" + viewType, "", null, "false", "addNewCodePopupId");
     }
     else { // 2 OR 3 == edit OR VIEW
         fn_editCode(viewType);
     }
}

function fn_editCode(viewType){
    var selectedItems = AUIGrid.getSelectedItems(largeGridID);

    if (selectedItems.length <= 0) {
        Common.alert("<spring:message code='service.msg.NoRcd'/> ");
        return;
    }

    var defectId = selectedItems[0].item.defectId;
    var prodCat = selectedItems[0].item.prodCat == '-' && selectedItems[0].item.prodCat == '*' ? null : selectedItems[0].item.prodCat;
    var codeCatId = selectedItems[0].item.codeCatId;
    var defCode = selectedItems[0].item.defectCode;
    var prodCode = selectedItems[0].item.prodCode;
    var codeCatName = selectedItems[0].item.codeCatName;
    var stkId = selectedItems[0].item.stkId;
    var svcLargeCode = selectedItems[0].item.svcLargeCode == '-' ? null : selectedItems[0].item.svcLargeCode;
    Common.popupDiv("/services/codeMgmt/addEditCodePop.do?isPop=true&defectId=" + defectId + "&viewType=" + viewType + "&defCode=" + defCode
            + "&codeCatId=" + codeCatId + "&codeCatName=" + codeCatName + "&stkId=" + stkId+ "&prodCat=" + prodCat + "&prodCode=" + prodCode
            + "&svcLargeCode=" + svcLargeCode
            , "", null, "false", "addNewCodePopupId");

}

function fn_UpdStatus(){
    var selectedItems = AUIGrid.getSelectedItems(largeGridID);

    if (selectedItems.length <= 0) {
       Common.alert("<spring:message code='service.msg.NoRcd'/> ");
       return;
   }

    var codeCatId = selectedItems[0].item.codeCatId;
    var codeCatName = selectedItems[0].item.codeCatName;
    var defectCode = selectedItems[0].item.defectCode;
    var defectId = selectedItems[0].item.defectId;
    var stusId = selectedItems[0].item.stusId;

    if(codeCatId == '7326'){ //Product Setting
    	Common.alert("Unable to change status of product");
        return;
    }

    Common.ajax("POST", "/services/codeMgmt/updateCodeStus.do", { codeCatId: codeCatId , codeCatName : codeCatName, defectCode : defectCode, defectId : defectId, stusId: stusId},
            function(result) {
              Common.alert(result.message);
              //fn_selectListAjax();
    });
}

function fn_excelDown() {
    // type : "xlsx", "csv", "txt", "xml", "json", "pdf", "object"
    var today = new Date();
    var dd = String(today.getDate()).padStart(2, '0');
    var mm = String(today.getMonth() + 1).padStart(2, '0'); //January is 0!
    var yyyy = today.getFullYear();

    GridCommon.exportTo("largeGrid", "xlsx", "Service Code Management List" + yyyy + mm + dd);
}

</script>

    <section id="content">
      <!-- content start -->
      <ul class="path">
        <li><img src="${pageContext.request.contextPath}/resources/images/common/path_home.gif" alt="Home" /></li>
        <li>Services</li>
        <li>Code Management</li>
      </ul>

      <aside class="title_line">
        <!-- title_line start -->
        <p class="fav"><a href="#" class="click_add_on">My menu</a></p>
        <h2>Service Code Management</h2>
        <ul class="right_btns">
	        <c:if test="${PAGE_AUTH.funcView == 'Y'}">
	            <li><p class="btn_blue"><a href="#" onclick="javascript:fn_UpdStatus()">Activate/Deactivate</a></p></li>
		        <li><p class="btn_blue"><a href="#" onclick="javascript:fn_selectCodeMgmtList();"><span class="search"></span>Search</a></p></li>
		    </c:if>
            <li><p class="btn_blue"><a href="#" onclick="javascript:fn_clear();"><span class="clear"></span>Clear</a></p></li>
        </ul>
      </aside><!-- title_line end -->


      <section class="search_table">
        <!-- search_table start -->
        <form id="MainForm" method="get" action="">
          <!-- <input type="hidden" id="hidTypeId" name="hidTypeId" value="" /> -->

          <table class="type1">
            <!-- table start -->
            <caption>table</caption>
            <colgroup>
              <col style="width:150px" />
              <col style="width:*" />
            </colgroup>
            <tbody>
              <tr>
                <th scope="row">Type</th>
                <td>
                <select class="w100p" id="cmbType" name="type""></select>
                </td>
                <th scope="row"><spring:message code="sal.title.text.productCategory" /></th>
			    <td>
			    <select class="multy_select w100p" multiple="multiple" id="cmbProductCtgry" name="productCtgry">
                     <c:forEach var="list" items="${prodCatList}" varStatus="status">
                        <option value="${list.codeId}">${list.codeName}</option>
                     </c:forEach>
                </select>
			    </td>
                <th scope="row">Business Category</th>
                <td>
                <select class="w100p" id="cmbBusiCtgry" name="busiCtgry"></select>
                </td>
              </tr>
              <tr>
                <th scope="row">Code Category</th>
                <td>
                <select class="w100p" id="cmbCodeCat" name="codeCat"></select>
                </td>
                <th scope="row">Status</th>
                <td>
                <select class="multy_select w100p" multiple="multiple" id="codeStatus" name="codeStatus">
                     <c:forEach var="list" items="${codeStatus}" varStatus="status">
                        <option value="${list.stusCodeId}">${list.codeName}</option>
                     </c:forEach>
                </select>
                </td>
                <th scope="row">Defect Code</th>
			    <td>
			        <input type=text name="defCode" id="defCode" class="w100p" value=""/>
			    </td>
              </tr>
              <tr>
			    <th scope="row">Product Code</th>
			    <td>
			    <input type=text name="prodCode" id="prodCode" class="w100p" value=""/>
			    </td>
			    <th scope="row">Defect Name</th>
                <td>
                    <input type=text name="defName" id="defName" class="w100p" value=""/>
                </td>
			    <th scope="row"></th><td></td>
			</tr>
            </tbody>
          </table><!-- table end -->

          <aside class="link_btns_wrap">
            <!-- link_btns_wrap start -->
            <p class="show_btn">
                <a href="javascript:void(0);">
                    <img src="${pageContext.request.contextPath}/resources/images/common/btn_link.gif" alt="link show" />
                </a>
            </p>
            <dl class="link_list">
		      <dt>Link</dt>
		      <dd>
		      <ul class="btns">
		         <li><p class="link_btn">
		          <a href="javascript:fn_addEditCodePop(1)" id="btnAddNewCode">Add New Code</a>
		         </p></li>
		         <li><p class="link_btn">
		          <a href="javascript:fn_addEditCodePop(2)" id="btnEditode">Edit Code Info</a>
		         </p></li>
		      </ul>
		      </dd>
		      </dl>
            </aside>

            <ul class="right_btns">
			    <li><p class="btn_grid">
			    <a href="#" onClick="fn_excelDown()"><spring:message code='service.btn.Generate' /></a></p></li>
			 </ul>
        </form>
      </section><!-- search_table end -->

      <section class="search_result">
        <!-- search_result start -->

        <article class="grid_wrap">
          <!-- grid_wrap start -->
          <!-- 그리드 영역 1-->
          <div id="largeGrid" style="width: 100%; height: 500px; margin: 0 auto;"></div>
        </article><!-- grid_wrap end -->

      </section><!-- search_result end -->

    </section><!-- content end -->