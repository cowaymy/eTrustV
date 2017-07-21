<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>

<style type="text/css">

/* 커스텀 칼럼 스타일 정의 */
.my-column {
    text-align:left;
    margin-top:-20px;
}
</style>

<script type="text/javaScript">
	$(function() {
		//doGetCombo('/common/selectCodeList.do', '11', '','cmbCategory', 'S' , 'f_multiCombo'); //Single COMBO => Choose One
		//doGetCombo('/common/selectCodeList.do', '11', '','cmbCategory', 'A' , 'f_multiCombo'); //Single COMBO => ALL
		//doGetCombo('/common/selectCodeList.do', '11', '','cmbCategory', 'M' , 'f_multiCombo'); //Multi COMBO
		// f_multiCombo 함수 호출이 되어야만 multi combo 화면이 안깨짐.
		// doGetCombo('/common/selectCodeList.do', '11', '','cmbCategory', 'S' , 'fn_multiCombo'); 
	});

	//Defalut MultiCombo
	function fn_multiCombo() {
		$('#cmbCategory').change(function() {
		}).multipleSelect({
			selectAll : true, // 전체선택 
			width : '100%'
		});
	}
	
	
	
	  
	// Make AUIGrid 
	var myGridID;
	var orgList = new Array();
	
	var orgGridCdList = new Array();
	var orgItemList = new Array();

	//Start AUIGrid
	$(document).ready(function() {

		// AUIGrid 그리드를 생성합니다.
		myGridID = GridCommon.createAUIGrid("grid_wrap", columnLayout,"orgSeq");

		// cellClick event.
		AUIGrid.bind(myGridID, "cellClick", function(event) {
			console.log("rowIndex : " + event.rowIndex + ", columnIndex : " + event.columnIndex + " clicked");
			fn_setDetail(myGridID, event.rowIndex);
		});

		// 에디팅 시작 이벤트 바인딩
		AUIGrid.bind(myGridID, "cellEditBegin", auiCellEditingHandler);

		// 에디팅 정상 종료 이벤트 바인딩
		AUIGrid.bind(myGridID, "cellEditEnd", auiCellEditingHandler); 

		// 에디팅 취소 이벤트 바인딩
		AUIGrid.bind(myGridID, "cellEditCancel", auiCellEditingHandler);

		// 행 추가 이벤트 바인딩 
		AUIGrid.bind(myGridID, "addRow", auiAddRowHandler);

		// 행 삭제 이벤트 바인딩 
		AUIGrid.bind(myGridID, "removeRow", auiRemoveRowHandler);

		//change orgCombo List
	
	$("#orgRgCombo").change(function() {
			$("#orgCombo").find('option').each(function() {
				$(this).remove();
			});
			if ($(this).val().trim() == "") {
				return;
			}
			$("#orgGubun").val("");
			fn_getOrgListAjax(); //call orgList
		});
		
	   fn_getOrgCodeListAjax();
	});

	//event management
	 function auiCellEditingHandler(event) {
		if (event.type == "cellEditEnd") {
			if (event.columnIndex == 4) {
				var val = event.value;
				$("#orgGubun").val("G");
				var data = getOrgCdData(val);
				AUIGrid.setCellValue(myGridID, event.rowIndex, event.columnIndex - 4, data.split(",")[0]);
				AUIGrid.setCellValue(myGridID, event.rowIndex, event.columnIndex - 3, data.split(",")[1]);
				AUIGrid.setCellValue(myGridID, event.rowIndex, event.columnIndex + 1, "");
			}  else if (event.columnIndex == 5) {
				var val = event.value;
                var data = getOrgItemData(val);
				AUIGrid.setCellValue(myGridID, event.rowIndex, event.columnIndex - 2, "");
				AUIGrid.setCellValue(myGridID, event.rowIndex, event.columnIndex + 1, data);
			} 
		} else if (event.type == "cellEditBegin") {
			if (event.columnIndex == 5) {
                var val = AUIGrid.getCellValue(myGridID, event.rowIndex, event.columnIndex - 1);
                if (val == null || val == "" || val == "Please select") {
                    alert("Please select CD");
                    return false;
                }
			}
		}

	}
	
    function getOrgCdData(val) {
        var retStr = "";
        $.each(orgGridCdList, function(key, value) {
            var id = value.value;
            if (id == val) {
                retStr = value.orggrcd + "," + value.id;
            }
        });
        return retStr;
    }
    
    function getOrgItemData(val) {
        var retStr = "";
        $.each(orgItemList, function(key, value) {
            var id = value.value;
            if (id == val) {
            	console.log(value.cdds);
                retStr = value.cdds;
            }
        });
        return retStr;
    }

	// 행 추가 이벤트 핸들러
	function auiAddRowHandler(event) {
	}
	// 행 삭제 이벤트 핸들러
	function auiRemoveRowHandler(event) {
	}

	
	function getOrgRgCodeNmList(){
        var grpList = new Array();
		$.each(orgGridCdList, function(key, value) {
			var list = new Object();
			list.id = value.id;
			list.value = value.value;
			list.cdnm = value.cdnm;
			list.orggrcd = value.orggrcd;
			
			grpList.push(list);
		});
		return grpList;
	}
	
	function getOrgRgCodeItemList(val,callBack){
		Common.ajaxSync("GET", "/commission/system/selectOrgItemList?orgNm="+val, $("#searchForm").serialize(), function(result) {
			orgItemList = new Array();
			for (var i = 0; i < result.length; i++) {
				var list = new Object();
				list.id = result[i].cdid;
				list.value = result[i].cd;
				list.cdnm = result[i].cdnm;
				list.cdds = result[i].cdds;
				orgItemList.push(list);
			}
			if (callBack) {
			    callBack(orgItemList);
			} 
		});
		return orgItemList;
	}
        
	//Make useYn ComboList
	function getUseYnComboList() {
		var list = [ "Y", "N" ];
		return list;
	}

	// AUIGrid 칼럼 설정
	var columnLayout = [ {
		dataField : "orgGrCd",
		headerText : "ORG GR CD",
		width : 120 ,
        visible : false 
	}, {
        dataField : "orgCd",
        headerText : "ORG CD",
        width : 120 ,
        visible : false 
    }, {
        dataField : "orgSeq",
        headerText : "ORG SEQ",
        width : 120 ,
        visible : false 
    }, {
        dataField : "itemSeq",
        headerText : "ITEM SEQ",
        width : 120 ,
        visible : false 
    }, {
        dataField : "orgNm",
        headerText : "ORG NAME",
        width : 120,
        editRenderer : {
            type : "ComboBoxRenderer",
            showEditorBtnOver : true, // 마우스 오버 시 에디터버턴 보이기
            listFunction : function(rowIndex, columnIndex, item, dataField) {
            	var list = getOrgRgCodeNmList();
                return list;
            },
            keyField : "value",
            valueField : "value",
        }
    },{
        dataField : "itemCode",
        headerText : "ITEM CODE",
        width : 120,
        editRenderer : {
            type : "ComboBoxRenderer",
            showEditorBtnOver : true, // 마우스 오버 시 에디터버턴 보이기
            listFunction : function(rowIndex, columnIndex, item, dataField) {
            	var list = getOrgRgCodeItemList(item.orgNm);
                return list;
            },
            keyField : "value",
            valueField : "value"
        }
    }, {
		dataField : "cdDs",
		headerText : "Description",
		editable : false,
		style : "my-column",
		width : 180
	}, {
        dataField : "editBtn",
        headerText : "Management<br>RULE",
        width : 120,
        editRenderer : {
        	type : "ButtonRenderer",
            labelText : "상세 보기",
            onclick : function(rowIndex, columnIndex, value, item) {
                alert("( " + rowIndex + ", " + columnIndex + " ) " + item.name + " EDIT");
            }
        }
    }, {
        dataField : "useYn",
        headerText : "USE YN",
        width : 120,
        editRenderer : {
            type : "ComboBoxRenderer",
            showEditorBtnOver : true, // 마우스 오버 시 에디터버턴 보이기
            listFunction : function(rowIndex, columnIndex, item, dataField) {
                var list = getUseYnComboList();
                return list;
            },
            keyField : "id"
        }
    }, {
        dataField : "type",
        headerText : "TYPE",
        width : 120
    },{
        dataField : "endDt",
        headerText : "END DATE",
        editable : false,
        width : 120
    }, {
		dataField : "orgSeq",
		headerText : "",
		width : 0
	} ];


	//get Ajax data and set organization combo data

	function fn_getOrgListAjax(callBack) {
		Common.ajaxSync("GET", "/commission/system/selectOrgCdList", $("#searchForm").serialize(), function(result) {
			orgList = new Array();
			var orgGubun = $("#orgGubun").val();
			if (orgGubun == "G") { //get Grid Combo Data
				for (var i = 0; i < result.length; i++) {
					var list = new Object();
					list.id = result[i].cdid;
					list.value = result[i].cd;
					list.cdnm = result[i].cdnm;
					list.orggrcd = result[i].orggrcd;
					orgList.push(list);
				}
			} else { //get 
				$("#orgCombo").append("<option value='' ></option>");
				for (var i = 0; i < result.length; i++) {
					$("#orgCombo").append("<option value='"+result[i].cdid + "' > " + result[i].cd + "</option>");
				}
			}
			//if you need callBack Function , you can use that function
			if (callBack) {
				callBack(orgList);
			}
		});
	}
	
	function fn_getOrgCodeListAjax(callBack) {
        $("#orgGubun").val("G");
        Common.ajaxSync("GET", "/commission/system/selectOrgCdList", $("#searchForm").serialize(), function(result) {
            var orgGubun = $("#orgGubun").val();
            orgList = new Array();
            for (var i = 0; i < result.length; i++) {
                var list = new Object();
                list.id = result[i].cdid;
                list.value = result[i].cd;
                list.cdnm = result[i].cdnm;
                list.orggrcd = result[i].orggrcd;
                orgGridCdList.push(list);
            }
            if (callBack) {
                callBack(orgList);
            }
        });
    }
	

	// get Ajax Data and set grid data
	function fn_getRuleBookItemMngListAjax() {
		Common.ajax("GET", "/commission/system/selectRuleBookItemMngList", $("#searchForm").serialize(), function(result) {
			console.log("성공.");
			console.log("data : " + result);
			AUIGrid.setGridData(myGridID, result);
		});
	}

	var cnt = 0;

	// make new rowdata
	function addRow() {
		var item = new Object();
		item.orgGrCd = "";
		item.orgCd = "";
		item.orgSeq = "";
		item.itemSeq = "";
		item.orgNm = "Please select";
		item.itemCode = "Please select";
		item.cdDs = "";
		item.useYn = "";
		item.endDt = "";
		item.orgSeq = "";

		// parameter
		// item : 삽입하고자 하는 아이템 Object 또는 배열(배열인 경우 다수가 삽입됨)
		// rowPos : rowIndex 인 경우 해당 index 에 삽입, first : 최상단, last : 최하단, selectionUp : 선택된 곳 위, selectionDown : 선택된 곳 아래
		AUIGrid.addRow(myGridID, item, "first");
	}

</script>


<section id="content">
	<!-- content start -->
	<ul class="path">
		<li><img src="image/path_home.gif" alt="Home" /></li>
		<li>Sales</li>
		<li>Order list</li>
	</ul>

	<aside class="title_line">
		<!-- title_line start -->
		<p class="fav">
			<a href="#" class="click_add_on">My menu</a>
		</p>
		<h2>Commission Rule Book Item Management</h2>
		
		<ul class="right_btns">
                <li><p class="btn_gray">
                        <a href="javascript:fn_getRuleBookItemMngListAjax();"><span class="search"></span>Search</a>
                    </p></li>
            </ul>
		
	</aside>
	<!-- title_line end -->

	<section class="search_table">
		<!-- search_table start -->
		<form id="searchForm" action="" method="post">

			<table class="type1">
				<!-- table start -->
				<caption>search table</caption>
				<colgroup>
					<col style="width: 110px" />
					<col style="width: *" />
					<col style="width: 110px" />
					<col style="width: *" />
					<col style="width: 110px" />
					<col style="width: *" />
					<col style="width: 110px" />
          <col style="width: *" />
				</colgroup>
				<tbody>
					<tr>
						<th scope="row">Month/Year</th>
						<td><input type="text" id="searchDt" name="searchDt" title="Month/Year" class="j_date2" value="${searchDt }" style="width:200px;" /></td>
						<th scope="row">ORG Group</th>
						<td><select id="orgRgCombo" name="orgRgCombo" style="width:100px;">
								<option value=""></option>
								<c:forEach var="list" items="${orgGrList }">
									<option value="${list.cdid}">${list.cd}</option>
								</c:forEach>
						</select></td>
						<th scope="row">ORG Code</th>
						<td><select id="orgCombo" name="orgCombo" style="width:100px;">
								<option value=""></option>
								<c:forEach var="list" items="${orgList }">
									<option value="${list.cdid}">${list.cd}</option>
								</c:forEach>
						</select></td>
						<input type="hidden" id="orgGubun" name="orgGubun" value="">
						<input type="hidden" id="orgGrCd" name="orgGrCd" value="">
						<th scope="row">USE YN</th>
            <td>
              <select id="useYnCombo" name="useYnCombo" style="width:100px;">
                <option value=""></option>
                <option value="Y">Y</option>
                <option value="N">N</option>
            </select>
            </td>
					</tr>
				</tbody>
			</table>
			<!-- table end -->
		</form>
	</section>
	<!-- search_table end -->

	<section class="search_result">
		<!-- search_result start -->
		<ul class="right_btns">
			<!--   <li><p class="btn_grid"><a href="#"><span class="search"></span>EXCEL UP</a></p></li>
    <li><p class="btn_grid"><a href="#"><span class="search"></span>EXCEL DW</a></p></li>
    <li><p class="btn_grid"><a href="#"><span class="search"></span>DEL</a></p></li>
    <li><p class="btn_grid"><a href="#"><span class="search"></span>INS</a></p></li> -->
			<li><p class="btn_grid">
					<a href="javascript:addRow();"><span class="search"></span>ADD</a>
					 <a href="javascript:fn_saveGridMap();">Save</a>
				</p></li>
		</ul>

		<article class="grid_wrap">
			<!-- grid_wrap start -->
			<div id="grid_wrap" style="width: 100%; height: 500px; margin: 0 auto;"></div>
		</article>
		<!-- grid_wrap end -->

	</section>
	<aside class="bottom_msg_box"><!-- bottom_msg_box start -->
  <p></p>
  </aside><!-- bottom_msg_box end -->
	<!-- search_result end -->

</section>
<!-- content end -->

</section>
<!-- container end -->
<hr />

</div>
<!-- wrap end -->
</body>
</html>

