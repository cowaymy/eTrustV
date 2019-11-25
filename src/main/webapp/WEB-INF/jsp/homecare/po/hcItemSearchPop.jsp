<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp" %>
<script type="text/javascript" src="${pageContext.request.contextPath}/resources/js/homecare-js-1.0.js"></script>
<style type="text/css">

/* 커스컴 disable 스타일*/
.mycustom-disable-color {
    color : #cccccc;
}

/* 그리드 오버 시 행 선택자 만들기 */
.aui-grid-body-panel table tr:hover {
    background:#D9E5FF;
    color:#000;
}
.aui-grid-main-panel .aui-grid-body-panel table tr td:hover {
    background:#D9E5FF;
    color:#000;
}

</style>

<script type="text/javaScript">
var myGridID;


var uomDs = [];
var uomObj = {};
<c:forEach var="obj" items="${uomList}">
  uomDs.push({codeId:"${obj.codeId}", codeName:"${obj.codeName}", code:"${obj.code}"});
  uomObj["${obj.codeId}"] = "${obj.codeName}";
</c:forEach>

var curDs = [];
var curObj = {};
<c:forEach var="obj" items="${curList}">
  curDs.push({codeId:"${obj.codeId}", codeName:"${obj.codeName}", code:"${obj.code}"});
  curObj["${obj.codeId}"] = "${obj.codeName}";
</c:forEach>

var gridoptions = {showRowCheckColumn:true, selectionMode:"singleRow", showStateColumn : false , editable : false, pageRowCount : 15, usePaging : true, useGroupingPanel : false};
var comboData = [{"codeId": "1","codeName": "Active"},{"codeId": "7","codeName": "Obsolete"},{"codeId": "8","codeName": "Inactive"}];
var gb;
$(document).ready(function(){
    var col;
    gb = "${url.isgubun}";

   var cmbCategoryDs = [{codeId:"5706", codeName:"Mattress"}, {codeId:"5707", codeName:"Frame"}];

   if(gb == "stock"){
        col  = stockLayout;
        //doGetCombo('/common/selectCodeList.do', '11', '','cmbCategory', 'M' , 'f_multiCombo'); //청구처 리스트 조회
        doDefCombo(cmbCategoryDs, '', 'cmbCategory', 'M', 'f_multiCombo');
        doGetCombo('/common/selectCodeList.do', '15', '','cmbType', 'M' , 'f_multiCombo'); //청구처 리스트 조회
        doDefCombo(comboData, '','cmbStatus', 'M', 'f_multiCombo');
    }else if(gb == "stocklist"){
    	opener.f_showModal();
    	gridoptions = {showRowCheckColumn : true, selectionMode : "multipleRows", showStateColumn : false , editable : false, pageRowCount : 15, usePaging : true, useGroupingPanel : false };
        col  = stockLayout;
        //doGetCombo('/common/selectCodeList.do', '11', '','cmbCategory', 'M' , 'f_multiCombo'); //청구처 리스트 조회
        doDefCombo(cmbCategoryDs, '', 'cmbCategory', 'M', 'f_multiCombo');
        doGetCombo('/common/selectCodeList.do', '15', '','cmbType', 'M' , 'f_multiCombo'); //청구처 리스트 조회
        doDefCombo(comboData, '','cmbStatus', 'M', 'f_multiCombo');
    }

    //$("#cmbCategory").val(["5706", "5707"]);
    //$("#cmbCategory option[value='5707']").prop("selected", true);
    //$("#cmbCategory").prop('disabled',true);

    $("#scode").val("${url.svalue}");
    $("#memAccId").val("${url.hMemAccId}");

    myGridID = GridCommon.createAUIGrid("grid_wrap", col, null, gridoptions);

    if ($("#scode").val() != ""){
        fn_SearchList();
    }

    // 셀 더블클릭 이벤트 바인딩
	if (gb != "stocklist"){
		  AUIGrid.bind(myGridID, "cellDoubleClick", function(event) {
			    var selectedItems = AUIGrid.getSelectedItems(myGridID);
			    opener.fn_itempopList(selectedItems);
			    self.close();
	      });
    }else{
    	AUIGrid.showColumnByDataField(myGridID, "cur");
        AUIGrid.showColumnByDataField(myGridID, "purchsPrc");
    }


});

$(function(){
	$('#search').click(function() {
        fn_SearchList();
    });
    $('#transfer').click(function(){
    	var selectedItems = AUIGrid.getCheckedRowItems(myGridID);
    	if(selectedItems.length > 0){
    	    var tet = opener.fn_itempopList(selectedItems);
    	}

    	if(gb == "stocklist"){
            opener.hideModal();
        }

    	self.close();
    })
});

//AUIGrid 칼럼 설정
var stockLayout = [ { dataField:"itemId", headerText:"Item id", width:120, visible:false },
                    { dataField:"itemCode", headerText:"Code", width:200, visible:true  },
                    { dataField:"itemName", headerText:"Name", width:200, visible:true  },
                    { dataField:"categoryId", headerText:"Category", width:120, visible:false  },
                    { dataField:"categoryName", headerText:"Category", width:120, visible:true  },
                    { dataField:"typeId", headerText:"Type", width:120, visible:false  },
                    { dataField:"typeName", headerText:"Type", width:120, visible:true  },
                    { dataField:"stateId", visible:false },
                    { dataField:"serialChk", headerText:"SerialChk", width:120, visible:false  },
                    { dataField:"uom", headerText:"UOM", width:120, visible:true
	                    , labelFunction:function(rowIndex, columnIndex, value, headerText, item ) {
	                        return uomObj[value]==null?"":js.String.strNvl(uomObj[value]);
	                    }
                    },
                    { dataField:"cur", headerText:"CUR", width:120, visible:false
                        , labelFunction:function(rowIndex, columnIndex, value, headerText, item ) {
                    	    return curObj[value]==null?"":js.String.strNvl(curObj[value]);
                        }
                    },
                    { dataField:"purchsPrc", headerText:"Price", width:120, visible:false
                    	, style:"aui-grid-user-custom-right"
                        , dataType:"numeric"
                        , formatString:"#,##0.0"
                    }
                  ]



function fn_SearchList() {
    var sUrl = "/homecare/po/selectHcItemSearch.do";
    var param = $('#searchForm').serializeJSON();

    Common.ajax("POST" , sUrl , param , function(data){
    	AUIGrid.setGridData(myGridID, data.data);
    });
}

function f_multiCombo() {
    $(function() {
        $('#cmbCategory').change(function() {

        }).multipleSelect({
            selectAll : true, // 전체선택
            width : '80%'
        });
        $('#cmbType').change(function() {

        }).multipleSelect({
            selectAll : true,
            width : '80%'
        });
        $('#cmbStatus').change(function() {

        }).multipleSelect({
            selectAll : true,
            width : '80%'
        });
    });
}

function f_multuComboLoc(){
	$('#locgb').change(function() {

    }).multipleSelect({
        selectAll : true,
        width : '80%'
    });
}

function closePop(){
    if(gb == "stocklist"){
        opener.hideModal();
    }
}
</script>

<body onunload="javascript:closePop();">

<section id="content"><!-- content start -->
	<ul class="path">
	    <li><img src="${pageContext.request.contextPath}/resources/images/common/path_home.gif" alt="Home" /></li>
	    <li>Search</li>
	    <li>Popup</li>
	</ul>

	<aside class="title_line"><!-- title_line start -->
	<h2>Item Search</h2>
	<ul class="right_btns">
	    <li><p class="btn_blue"><a id="search"><span class="search"></span>Search</a></p></li>
	    <li><p class="btn_blue"><a id="transfer">transfer</a></p></li>
	</ul>
	</aside><!-- title_line end -->

	<section class="search_table"><!-- search_table start -->
	<form id="searchForm" method="post">
	    <input id="memAccId" name="memAccId" type="hidden" />
		<table class="type1"><!-- table start -->
		<caption>table</caption>
		<colgroup>
		    <col style="width:120px" />
		    <col style="width:*" />
		    <col style="width:120px" />
		    <col style="width:*" />
		    <col style="width:120px" />
		    <col style="width:*" />
		</colgroup>
		<tbody>
			<tr>
			    <th scope="row">Search Code</th>
			    <td>
			    <input type="text" id="scode" name="scode" placeholder="Search Code" class="w100p" />
			    </td>
			    <th scope="row">Search Name</th>
			    <td colspan="3">
			    <input type="text" id="sname" name="sname" placeholder="Search Name" class="w100p" />
			    </td>
			</tr>
			<tr>
		       <th scope="row">Category</th>
		       <td>
		           <select class="w100p" id="cmbCategory" name="cmbCategory[]"></select>
		       </td>
		       <th scope="row">Type</th>
		       <td>
		           <select class="w100p" id="cmbType" name="cmbType[]"></select>
		       </td>
		       <th scope="row">Status</th>
		       <td>
		           <select class="w100p" id="cmbStatus" name="cmbStatus[]"></select>
		       </td>
		   </tr>
		</tbody>
		</table><!-- table end -->
	</form>
	</section><!-- search_table end -->

	<section class="search_result"><!-- search_result start -->
		<article class="grid_wrap"><!-- grid_wrap start -->
		    <div id="grid_wrap" style="height:320px;"></div>
		</article><!-- grid_wrap end -->

	</section><!-- search_result end -->

</section><!-- content end -->
</body>

