<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>

<script type="text/javaScript" language="javascript">

var listMyGridID;
var memCode;

$(document).ready(function() {

	 $("#netSalesMonth").val(moment().format('MM/YYYY'));
	 bindValue();
	 createAUIGrid();

     AUIGrid.bind(listMyGridID, "cellDoubleClick", function(event) {

         var index = AUIGrid.getSelectedIndex(listMyGridID)[0];
         var param;

         param = {
        	         orgCode  : AUIGrid.getCellValue(listMyGridID, event.rowIndex, "orgCode"),
			         grpCode  : AUIGrid.getCellValue(listMyGridID, event.rowIndex, "grpCode"),
			         deptCode : AUIGrid.getCellValue(listMyGridID, event.rowIndex, "deptCode"),
			         memCode  : AUIGrid.getCellValue(listMyGridID, event.rowIndex, "memCode"),
			         position  : AUIGrid.getCellValue(listMyGridID, event.rowIndex, "position")
         }

         Common.popupDiv("/organization/smfDailyInfoPop.do", param, null, true,'');

     });

    getMemCode();
    doGetComboOrder('/sales/order/colorGridProductList.do', '', '', '', 'cmbProduct', 'M', 'f_multiCombo'); //Common Code
    doGetCombo('/sales/promotion/selectProductCategoryList.do', '', '', 'cmbProductCtgry', 'M','f_multiCombo'); //Category
});


function getMemCode(){
    Common.ajax("GET", "/organization/selectSimulatedMemberCRSCode.do" , null, function (result2) {
           if('${SESSION_INFO.userTypeId}' == 1 && '${SESSION_INFO.roleId}' != 111) {
               memCode = '${SESSION_INFO.userName}';
           }
           else {
               memCode = result2[0].memCode;
          }

           $("#Code").val(memCode);
           $("#Code").attr("class", "w100p readonly");
           fn_selectListAjax();
      });
}

function bindValue(){
    if("${memType}"== "1"){
        var orgCode = '${orgCode}';
        var grpCode = '${grpCode}';
        var deptCode = '${deptCode}';
        orgCode = orgCode.replace(/^\s+|\s+$/gm,'');
        grpCode = grpCode.replace(/^\s+|\s+$/gm,'');
        deptCode = deptCode.replace(/^\s+|\s+$/gm,'');

        if("${SESSION_INFO.memberLevel}" =="1"){
           $("#orgCode").attr("class", "w100p readonly");
           $("#orgCode").attr("readonly", "readonly");
           $("#orgCode").val(orgCode);

       }else if("${SESSION_INFO.memberLevel}" =="2"){
           $("#orgCode").attr("class", "w100p readonly");
           $("#orgCode").attr("readonly", "readonly");
           $("#orgCode").val(orgCode);

           $("#grpCode").attr("class", "w100p readonly");
           $("#grpCode").attr("readonly", "readonly");
           $("#grpCode").val( grpCode);

       }else if("${SESSION_INFO.memberLevel}" =="3"){
           $("#orgCode").attr("class", "w100p readonly");
           $("#orgCode").attr("readonly", "readonly");
           $("#orgCode").val(orgCode);

           $("#grpCode").attr("class", "w100p readonly");
           $("#grpCode").attr("readonly", "readonly");
           $("#grpCode").val( grpCode);

           $("#deptCode").attr("class", "w100p readonly");
           $("#deptCode").attr("readonly", "readonly");
           $("#deptCode").val( deptCode);

       }
       else if("${SESSION_INFO.memberLevel}" =="4"){
           $("#orgCode").attr("class", "w100p readonly");
           $("#orgCode").attr("readonly", "readonly");
           $("#orgCode").val(orgCode);

           $("#grpCode").attr("class", "w100p readonly");
           $("#grpCode").attr("readonly", "readonly");
           $("#grpCode").val(grpCode);

           $("#deptCode").attr("class", "w100p readonly");
           $("#deptCode").attr("readonly", "readonly");
           $("#deptCode").val(deptCode);

           $("#memCode").attr("class", "w100p readonly");
           $("#memCode").attr("readonly", "readonly");
           $("#memCode").val("${SESSION_INFO.userName}");
       }
    }
}

function f_multiCombo(){
    $(function() {

        $('#cmbProduct').change(function() {

        }).multipleSelect({
            selectAll: true, // 전체선택
            width: '80%'
        });

        $('#cmbProductCtgry').change(function() {

        }).multipleSelect({
            selectAll: true, // 전체선택
            width: '80%'
        });

    });
}

function createAUIGrid() {

    //AUIGrid 칼럼 설정
    var columnLayout = [
        { headerText : "Org Code", dataField : "orgCode",       editable : false, width : 80  }
      , { headerText : "Grp Code", dataField : "grpCode",       editable : false, width : 80  }
      , { headerText : "Dept Code", dataField : "deptCode",       editable : false, width : 80  }
      , { headerText : "Member Code", dataField : "memCode",       editable : false, width : 80  }
      , { headerText : "CRS Code",  dataField : "crsCode", editable : false, width : 80 , visible: false }
      , { headerText : "Name", dataField : "fullName", editable : false, width : 80  }
      , { headerText : "GM Code",   dataField : "orgCode",       editable : false, width : 100 }
      , { headerText : "Position",  dataField : "position",       editable : false, width : 100  }
      , { headerText : "Month",    dataField : "month", editable : false, width : 150 }
      , { headerText : "Product Category", dataField : "productctgry",    editable : false}
      , { headerText : "Product Desc", dataField : "productname",    editable : false}
      , { headerText : "Key In",    editable : false, width : 70 ,
    	  children : [
    	 {dataField : "keyinW1",
          headerText : "Week 1",
          width : 100
          },
          {dataField : "keyinW2",
            headerText : "Week 2",
            width : 100
          },
          {dataField : "keyinW3",
            headerText : "Week 3",
            width : 100
           },
           {dataField : "keyinW4",
             headerText : "Week 4",
             width : 100
           },
           {dataField : "keyinTotalAmt",
             headerText : "Total Key In",
             width : 100
            }
      ,]}

      , { headerText : "Overall Net Sales Target",   dataField : "targetatmtNs",      editable : false, width : 100 }
      , { headerText : "Accumulated Net", dataField : "netsalesTotalAmt",   editable : false, width : 100 }
      , { headerText : "Net Rate",  dataField : "netRate", editable : false, width : 60  }
      , { headerText : "Overall Active HP",   dataField : "acthp", editable : false, width : 60  }
      , { headerText : "Overall Newly Recruit",  dataField : "recruit", editable  : false }
      , { headerText : "Overall DR", dataField : "directRecruit", editable  : false }
      , { headerText : "Overall Active New Neo", dataField : "newNeoAct", editable  : false }
      , { headerText : "Overall Part time", dataField : "parttime", editable  : false }
      , { headerText : "Overall New Neo Active Rate", dataField : "newNeoActRate", editable  : false }
      , { headerText : "Overall Neo Pro Productivity", dataField : "neoProProductivity", editable  : false }
      , { headerText : "Overall Part time Productivity", dataField : "parttimeProductivity", editable  : false }
      , { headerText : "SHI", dataField : "shi", editable  : false }
        ];

    //그리드 속성 설정
    var gridPros = {
        usePaging           : true,         //페이징 사용
        pageRowCount        : 20,           //한 화면에 출력되는 행 개수 20(기본값:20)
        editable            : false,
        fixedColumnCount    : 1,
        showStateColumn     : false,
        displayTreeOpen     : false,
      //selectionMode       : "singleRow",  //"multipleCells",
        headerHeight        : 30,
        useGroupingPanel    : false,        //그룹핑 패널 사용
        skipReadonlyColumns : true,         //읽기 전용 셀에 대해 키보드 선택이 건너 뛸지 여부
        wrapSelectionMove   : true,         //칼럼 끝에서 오른쪽 이동 시 다음 행, 처음 칼럼으로 이동할지 여부
        showRowNumColumn    : true,         //줄번호 칼럼 렌더러 출력
        noDataMessage       : "No record found.",
        groupingMessage     : "Here groupping"
    };

    listMyGridID = GridCommon.createAUIGrid("list_grid_wrap", columnLayout, "", gridPros);
//     	 fn_selectListAjax();

}


$(function(){
	  $('#btnSrch').click(function() {
         fn_selectListAjax();
      });

	   $("#download").click(function() {
	        GridCommon.exportTo("list_grid_wrap", 'xlsx', "Performance View List");
	    });

	   $('#btnActHP').click(function() {
           Common.popupDiv("/organization/smfActHpPop.do", null, null, true);
       });

	   $('#btnHA').click(function() {
           Common.popupDiv("/organization/smfHAPop.do", null, null, true);
       });

	   $('#btnHC').click(function() {
           Common.popupDiv("/organization/smfHCPop.do", null, null, true);
       });
});

function fn_selectListAjax() {

    if(!$("#netSalesMonth").val()){
    	Common.alert("Please choose the Month");
    	return;
    }
    Common.ajax("GET", "/organization/selectPerformanceView.do", $("#listSearchForm").serialize(), function(result) {
        AUIGrid.setGridData(listMyGridID, result);
    });
}



$.fn.clearForm = function() {
    return this.each(function() {
        var type = this.type, tag = this.tagName.toLowerCase();
        if (tag === 'form'){
            return $(':input',this).clearForm();
        }
        if (type === 'text' || type === 'password'  || tag === 'textarea'){
            if($("#"+this.id).hasClass("readonly")){

            }else{
                this.value = '';
            }
        }else if (type === 'checkbox' || type === 'radio'){
            this.checked = false;

        }else if (tag === 'select'){
            if($("#memType").val() != "7"){ //check not HT level
                 this.selectedIndex = 0;
            }
        }

        $("#cmbProductCtgry").multipleSelect("uncheckAll");
        $("#cmbProduct").multipleSelect("uncheckAll");
    });
};



</script>

<section id="content"><!-- content start -->
<ul class="path">
    <li><img src="${pageContext.request.contextPath}/resources/images/common/path_home.gif" alt="Home" /></li>
    <li>Organization</li>
    <li>Sales Monitoring File</li>
    <li>Performance View</li>
</ul>

<aside class="title_line mt30"><!-- title_line start -->
<p class="fav"><a href="#" class="click_add_on">My menu</a></p>
<h2>Performance View</h2>
<ul class="right_btns">
    <li><p class="btn_blue"><a id="btnSrch" href="#"><span class="search"></span><spring:message code='sales.Search'/></a></p></li>
    <li><p class="btn_blue"><a id="btnClear" href="#" onclick="javascript:$('#listSearchForm').clearForm();"><span class="clear"></span><spring:message code='sales.Clear'/></a></p></li>
</ul>
</aside><!-- title_line end -->

<section class="search_table mt30"><!-- search_table start -->


<!-- order overview report Form -->



<form id="listSearchForm" name="listSearchForm" action="#" method="post">

<table class="type1"><!-- table start -->
<caption>table</caption>
<colgroup>
    <col style="width:130px" />
    <col style="width:*" />
    <col style="width:160px" />
    <col style="width:*" />
    <col style="width:190px" />
    <col style="width:*" />
</colgroup>
<tbody>
<tr>
    <th scope="row">Code</th>
    <td><input id="Code" name="Code" type="text" title="Code"  class="w100p" readonly="readonly"/></td>

    <th scope="row">Org Code</th>
    <td><input id="orgCode" name="orgCode" type="text" title="orgCode"  class="w100p" /></td>

    <th scope="row">Grp Code</th>
    <td><input id="grpCode" name="grpCode" type="text" title="grpCode"  class="w100p" /></td>

    <th scope="row">Dept Code</th>
    <td><input id="deptCode" name="deptCode" type="text" title="deptCode"  class="w100p"/></td>
</tr>

<tr>
    <th scope="row">Name</th>
    <td><input id="memName" name="memName" type="text" title="memName"  class="w100p" /></td>

    <th scope="row">Member Code</th>
    <td><input id="memCode" name="memCode" type="text" title="memCode"  class="w100p" /></td>

    <th scope="row">Level</th>
    <td>
        <select id="memLvl" name="memLvl" class="multy_select w100p" multiple="multiple">
               <option value="1">GM</option>
               <option value="2">SM</option>
               <option value="3">HM</option>
               <option value="4">HP</option>
        </select>
    </td>

    <th scope="row">Month</th>
    <td><input type="text" title="기준년월" id="netSalesMonth" name="netSalesMonth" placeholder="MM/YYYY" class="j_date2 w100p" /></td>
</tr>

<tr>
    <th scope="row"><spring:message code="sal.title.text.productCategory" /></th>
    <td>
    <select class="w100p" id="cmbProductCtgry" name="cmbProductCtgry" multiple="multiple">
    </select>

        <th scope="row"><spring:message code="sal.title.text.product" /></th>
    <td>
    <select class="w100p" id="cmbProduct" name="cmbProduct" multiple="multiple">
    </select>
    </td>
    <th></th>
    <td></td>
    <th></th>
    <td></td>

</tr>

</tbody>
</table><!-- table end -->
</form>

<aside class="link_btns_wrap"><!-- link_btns_wrap start -->
<p class="show_btn"><a href="#"><img src="${pageContext.request.contextPath}/resources/images/common/btn_link.gif" alt="link show" /></a></p>
<dl class="link_list">
  <dt>Link</dt>
  <dd>
  <ul class="btns">
      <li><p class="link_btn"><a href="#" id="btnActHP">Active HP</a></p></li>
      <li><p class="link_btn"><a href="#" id="btnHA">HA</a></p></li>
      <li><p class="link_btn"><a href="#" id="btnHC">HC</a></p></li>
    </ul>
    <p class="hide_btn"><a href="#"><img src="${pageContext.request.contextPath}/resources/images/common/btn_link_close.gif" alt="hide" /></a></p>
    </dd>
</dl>
</aside><!-- link_btns_wrap end -->


  <section class="search_result"><!-- search_result start -->
   <ul class="right_btns">
   <li><p class="btn_grid"><a id="download">GENERATE</a></p></li>
   </section><!-- search_result end -->

<section class="search_result"><!-- search_result start -->

<article class="grid_wrap"><!-- grid_wrap start -->
    <div id="list_grid_wrap" style="width:100%; height:480px; margin:0 auto;"></div>
</article><!-- grid_wrap end -->

</section><!-- search_result end -->

</section><!-- content end -->
