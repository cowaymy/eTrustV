<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>

<style type="text/css">

/* 커스텀 칼럼 스타일 정의 */
.my-column {
    text-align:left;
    margin-top:-20px;
}
</style>

<script type="text/javaScript">
	  
	// Make AUIGrid 
	var myGridID;
	var grpOrgList = new Array(); // Group Organization List
	var orgList = new Array(); // Organization List

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

	});

	//event management
	function auiCellEditingHandler(event) {
		if (event.type == "cellEditEnd") {
			if (event.columnIndex == 0) {
				var val = event.value;
				var valNm = getOrgRgName(val);
				$("#orgGubun").val("G");
				AUIGrid.setCellValue(myGridID, event.rowIndex, event.columnIndex + 1, valNm);
				AUIGrid.setCellValue(myGridID, event.rowIndex, event.columnIndex + 2, "");
				AUIGrid.setCellValue(myGridID, event.rowIndex, event.columnIndex + 3, "");
				AUIGrid.setCellValue(myGridID, event.rowIndex, event.columnIndex + 4, "");
			} else if (event.columnIndex == 2) {
				var val = event.value;
				$("#orgGubun").val("G");
				var orgNm = AUIGrid.getCellFormatValue(myGridID, event.rowIndex, event.columnIndex);
				var data = getOrgData(val);
				AUIGrid.setCellValue(myGridID, event.rowIndex, event.columnIndex + 1, data.split(",")[0]);
				AUIGrid.setCellValue(myGridID, event.rowIndex, event.columnIndex + 2, data.split(",")[1]);
			}
		} else if (event.type == "cellEditBegin") {
			var orgSeq = AUIGrid.getCellValue(myGridID, event.rowIndex, 7);
			
			if (!AUIGrid.isAddedById(myGridID, orgSeq) && event.columnIndex != 5) {
				return false;
			}
			if (event.columnIndex == 2) {
				var val = AUIGrid.getCellValue(myGridID, event.rowIndex, event.columnIndex - 2);
				if (val == null || val == "" || val == "Please select" || val == "선택하세요.") {
					Common.alert("<spring:message code='sys.common.alert.validation' arguments='ORG GR CD' htmlEscape='false'/>");
					return false;
				}
				$("#orgGubun").val("G");
				var val = AUIGrid.getCellValue(myGridID, event.rowIndex, event.columnIndex - 2);
				$("#orgGrCd").val(val);
				fn_getOrgListAjax();
			}
		}
	};

	// 행 추가 이벤트 핸들러
	function auiAddRowHandler(event) {
	}

	// 행 삭제 이벤트 핸들러
	function auiRemoveRowHandler(event) {
	}
	
	//get Group Organization Combo Data
	function getOrgRgName(val) {
		var retStr = "";
		$("#orgRgCombo").find('option').each(function() {
			if (val == $(this).val()) {
				retStr = $(this).text();
			}
		});
		return retStr;
	}

	//get Organization Combo Data
	function getOrgData(val) {
		var retStr = "";
		$.each(orgList, function(key, value) {
			var id = value.id;
			if (id == val) {
				retStr = value.value + "," + value.cdds;
			}
			console.debug("id:" + value.id + ",cd:" + value.value + ",cdnm:" + value.cdnm);
		});
		return retStr;
	}

	//Make orgRgComboList
	function getOrgRgComboList() {
		grpOrgList = new Array();
		$("#orgRgCombo").find('option').each(function() {
			var list = new Object();
			list.id = $(this).val();
			list.value = $(this).text();
			grpOrgList.push(list);
		});
		return grpOrgList;
	}

	//Make useYn ComboList
	function getUseYnComboList() {
		var list = [ "Y", "N" ];
		return list;
	}
	
	// get Ajax Data and set grid data
    function fn_getRuleBookMngListAjax() {
        Common.ajax("GET", "/commission/system/selectRuleBookOrgMngList", $("#searchForm").serialize(), function(result) {
            console.log("성공.");
            console.log("data : " + result);
            AUIGrid.setGridData(myGridID, result);
        });
    }

	// AUIGrid 칼럼 설정
	var columnLayout = [ {
		dataField : "orgGrCd",
		headerText : "ORG GR CD",
		//width : 120,
		editRenderer : {
			type : "ComboBoxRenderer",
			showEditorBtnOver : true, // 마우스 오버 시 에디터버턴 보이기
			listFunction : function(rowIndex, columnIndex, item, dataField) {
				var list = getOrgRgComboList();
				return list;
			},
			keyField : "id",
			valueField : "value"
		},
        width : "10%"
	}, {
		dataField : "orgGrNm",
		headerText : "ORG GR NM",
		//width : 120,
		editable : false,
        width : "10%"
	}, {
		dataField : "orgCd",
		headerText : "ORG CD",
		//width : 120,
		/*   labelFunction : function(rowIndex, columnIndex, value,
		          headerText, item) {
		      var retStr = "";
		      for (var i = 0, len = orgList.length; i < len; i++) {
		          if (orgList[i]["value"] == value) {
		              retStr = orgList[i]["id"];
		              break;
		          }
		      }
		      return retStr == "" ? value : retStr;
		  }, */
		editRenderer : {
			type : "ComboBoxRenderer",
			showEditorBtnOver : true, // 마우스 오버 시 에디터버턴 보이기
			listFunction : function(rowIndex, columnIndex, item, dataField) {
				return orgList;
			},
			keyField : "id",
			valueField : "value"
		},
        width : "10%"
	}, {
		dataField : "orgNm",
		headerText : "ORG NAME",
		//width : 120,
		editable : false,
		style:"my-column",
        width : "10%"
    }, {
		dataField : "cdds",
		headerText : "DESCRIPTION",
		editable : false,
		//width : 180,
		style : "my-column"
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
		dataField : "endDt",
		headerText : "END DATE",
		//width : 120,
		editable : false,
        width : "10%"
	}, {
		dataField : "orgSeq",
		headerText : "",
		width : 0
	},{
        dataField : "updDt",
        headerText : "UPDATE",
        //width : 120,
        editable : false,
        width : "10%"
    } ];
	
    // 컬럼 선택시 상세정보 세팅.
    function fn_setDetail(gridID, rowIdx) {
        $("#id").val(AUIGrid.getCellValue(gridID, rowIdx, "id"));
        $("#name").val(AUIGrid.getCellValue(gridID, rowIdx, "name"));
        $("#description").val(AUIGrid.getCellValue(gridID, rowIdx, "description"));
    }

    var cnt = 0;

    // make new rowdata
    function addRow() {
        var item = new Object();
        item.orgGrCd = "<spring:message code='sys.info.grid.selectMessage'/>";
        item.orgGrNm = "";
        item.orgCd = "<spring:message code='sys.info.grid.selectMessage'/>";
        item.orgNm = "";
        item.cdDs = "";
        item.useYn = "Y";
        item.endDt = "";
        item.orgSeq = "";

        // parameter
        // item : 삽입하고자 하는 아이템 Object 또는 배열(배열인 경우 다수가 삽입됨)
        // rowPos : rowIndex 인 경우 해당 index 에 삽입, first : 최상단, last : 최하단, selectionUp : 선택된 곳 위, selectionDown : 선택된 곳 아래
        AUIGrid.addRow(myGridID, item, "first");
    }


	//get Ajax data and set organization combo data

	function fn_getOrgListAjax(callBack) {

		Common.ajaxSync("GET", "/commission/system/selectOrgList", $("#searchForm").serialize(), function(result) {
			orgList = new Array();
			var orgGubun = $("#orgGubun").val();
			if (orgGubun == "G") { //get Grid Combo Data
				for (var i = 0; i < result.length; i++) {
					var list = new Object();
					list.id = result[i].cdid;
					list.value = result[i].cdnm;
					list.cdnm = result[i].cd;
					list.cdds = result[i].cdds;
					orgList.push(list);
				}
			} else { //get 
				$("#orgCombo").append("<option value='' ></option>");
				for (var i = 0; i < result.length; i++) {
					$("#orgCombo").append("<option value='"+result[i].cdid + "' > " + result[i].cdnm + "</option>");
				}
			}
			//if you need callBack Function , you can use that function
			if (callBack) {
				callBack(orgList);
			}
		});
	}

	function validation() {
		var result = true;
		var addList = AUIGrid.getAddedRowItems(myGridID);
		var udtList = AUIGrid.getEditedRowItems(myGridID);
		if (addList.length == 0 && udtList.length == 0) {
			Common.alert("<spring:message code='sys.common.alert.noChange'/>");
			return false;
		}

		for (var i = 0; i < addList.length; i++) {
			var orgGrCd = addList[i].orgGrCd;
			var orgGrNm = addList[i].orgGrNm;
			var orgCd = addList[i].orgCd;
			var orgNm = addList[i].orgNm;
			var cdDs = addList[i].cdDs;
			var useYn = addList[i].useYn;
			var endDt = addList[i].endDt;
			var orgSeq = addList[i].orgSeq;
			if (orgGrCd == "" || orgGrCd == "Please select" || orgGrCd == "선택하세요.") {
				result = false;
				Common.alert("<spring:message code='sys.common.alert.validation' arguments='ORG GR CD' htmlEscape='false'/>");
				break;
			}
			if (orgGrNm == "") {
                result = false;
                Common.alert("<spring:message code='sys.common.alert.validation' arguments='ORG GR NM' htmlEscape='false'/>");
                break;
            }
			if (orgCd == "" || orgCd == "Please select" || orgCd == "선택하세요.") {
                result = false;
                Common.alert("<spring:message code='sys.common.alert.validation' arguments='ORG CD' htmlEscape='false'/>");
                break;
            }
			if (orgNm == "") {
                result = false;
                Common.alert("<spring:message code='sys.common.alert.validation' arguments='ORG NM' htmlEscape='false'/>");
                break;
            }
			if (useYn == "") {
                result = false;
                Common.alert("<spring:message code='sys.common.alert.validation' arguments='ORG GR CD' htmlEscape='false'/>");
                break;
            }
		}
		for (var i = 0; i < udtList.length; i++) {
			var orgGrCd = udtList[i].orgGrCd;
			var orgGrNm = udtList[i].orgGrNm;
			var orgCd = udtList[i].orgCd;
			var orgNm = udtList[i].orgNm;
			var cdDs = udtList[i].cdDs;
			var useYn = udtList[i].useYn;
			var endDt = udtList[i].endDt;
			var orgSeq = udtList[i].orgSeq;
			if (orgGrCd == "" || orgGrCd == "Please select" || orgGrCd == "선택하세요.") {
                result = false;
                Common.alert("<spring:message code='sys.common.alert.validation' arguments='ORG GR CD' htmlEscape='false'/>");
                break;
            }
            if (orgGrNm == "") {
                result = false;
                Common.alert("<spring:message code='sys.common.alert.validation' arguments='ORG GR NM' htmlEscape='false'/>");
                break;
            }
            if (orgCd == "" || orgCd == "Please select" || orgCd == "선택하세요.") {
                result = false;
                Common.alert("<spring:message code='sys.common.alert.validation' arguments='ORG CD' htmlEscape='false'/>");
                break;
            }
            if (orgNm == "") {
                result = false;
                Common.alert("<spring:message code='sys.common.alert.validation' arguments='ORG NM' htmlEscape='false'/>");
                break;
            }
            if (useYn == "") {
                result = false;
                Common.alert("<spring:message code='sys.common.alert.validation' arguments='ORG GR CD' htmlEscape='false'/>");
                break;
            }
		}
		return result;
	}

	//Save Data
	function fn_saveGridMap() {
		if (validation()) {
			  Common.confirm("<spring:message code='sys.common.alert.save'/>",fn_saveGridCall);
		}else{
			return ;
		}
	}
	
	function fn_saveGridCall() {
           Common.ajax("POST", "/commission/system/saveCommissionGrid.do", GridCommon.getEditData(myGridID), function(result) {
                 // 공통 메세지 영역에 메세지 표시.
             Common.setMsg("<spring:message code='sys.msg.success'/>");
               fn_getRuleBookMngListAjax();
           }, function(jqXHR, textStatus, errorThrown) {
               try {
                   console.log("status : " + jqXHR.status);
                   console.log("code : " + jqXHR.responseJSON.code);
                   console.log("message : " + jqXHR.responseJSON.message);
                   console.log("detailMessage : " + jqXHR.responseJSON.detailMessage);
               } catch (e) {
                   console.log(e);
               }
               Common.alert("Fail : " + jqXHR.responseJSON.message);
               fn_getSampleListAjax();
           });
	}
</script>


<section id="content">
	<!-- content start -->
	<ul class="path">
		<li><img src="${pageContext.request.contextPath}/resources/images/common/path_home.gif" alt="Home" /></li>
		<li><spring:message code='commission.text.head.commission'/></li>
		<li><spring:message code='commission.text.head.masterMgmt'/></li>
		<li><spring:message code='commission.text.head.organizationMgmt'/></li>
	</ul>

	<aside class="title_line">
		<!-- title_line start -->
		<p class="fav">
			<a href="#" class="click_add_on">My menu</a>
		</p>
		<h2><spring:message code='commission.title.organizationMgmt'/></h2>
		<ul class="right_opt">
			<li><p class="btn_blue">
                     <a href="javascript:fn_getRuleBookMngListAjax();"><span class="search"></span><spring:message code='sys.btn.search'/></a>
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
						<th scope="row"><spring:message code='commission.text.search.monthYear'/></th>
						<td><input type="text" id="searchDt" name="searchDt" title="Month/Year" class="j_date2" value="${searchDt }" style="width:200px;" /></td>
						<th scope="row"><spring:message code='commission.text.search.orgGroup'/></th>
						<td><select id="orgRgCombo" name="orgRgCombo" style="width:100px;">
								<option value=""></option>
								<c:forEach var="list" items="${orgGrList }">
									<option value="${list.cdid}">${list.cd}</option>
								</c:forEach>
						</select></td>
						<th scope="row"><spring:message code='commission.text.search.orgType'/></th>
						<td><select id="orgCombo" name="orgCombo" style="width:100px;">
								<option value=""></option>
								<c:forEach var="list" items="${orgList }">
									<option value="${list.cdid}">${list.cdnm}</option>
								</c:forEach>
						</select></td>
						<input type="hidden" id="orgGubun" name="orgGubun" value="">
						<input type="hidden" id="orgGrCd" name="orgGrCd" value="">
						<th scope="row"><spring:message code='commission.text.search.useYN'/></th>
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
			<!--   <li><p class="btn_grid"><a href="#">EXCEL UP</a></p></li>
    <li><p class="btn_grid"><a href="#">EXCEL DW</a></p></li>
    <li><p class="btn_grid"><a href="#">DEL</a></p></li>
    <li><p class="btn_grid"><a href="#">INS</a></p></li> -->
			<li>
    			<p class="btn_grid">
					<a href="javascript:addRow();"><spring:message code='sys.btn.add'/></a>
				</p>
			</li>
			<li>
				<p class="btn_grid">
                    <a href="javascript:fn_saveGridMap();"><spring:message code='sys.btn.save'/></a>
                </p>
			</li>
		</ul>

		<article class="grid_wrap">
			<!-- grid_wrap start -->
			<div id="grid_wrap" style="width: 100%; height: 500px; margin: 0 auto;"></div>
		</article>
		<!-- grid_wrap end -->

	</section>
	<!-- search_result end -->

</section>
<!-- content end -->

<!-- container end -->
<hr />

<!-- wrap end -->
</body>
</html>

