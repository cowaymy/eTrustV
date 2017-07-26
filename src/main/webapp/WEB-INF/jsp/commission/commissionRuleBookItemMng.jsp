<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>

<style type="text/css">

/* 커스텀 칼럼 스타일 정의 */
.my-column {
	text-align: left;
	margin-top: -20px;
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
	var myGridID2;
	var orgList = new Array(); //그룹 리스트
	var orgGridCdList = new Array(); //그리드 등록 그룹 리스트
	var orgItemList = new Array();   //그리드 등록 아이템 리스트

	//Start AUIGrid
	$(document).ready(function() {
		  
		//drag div
		$("#popup_wrap, .popup_wrap").draggable({handle: '.pop_header'});
		$("#popup_wrap2, .popup_wrap2").draggable({handle: '.pop_header'});
		
		// AUIGrid 그리드를 생성합니다.
		myGridID = GridCommon.createAUIGrid("grid_wrap", columnLayout,"itemSeq");
	//	myGridID2 = GridCommon.createAUIGrid("grid_wrap2", columnLayout2,"ruleSeq");

		// cellClick event.
		AUIGrid.bind(myGridID, "cellClick", function(event) {
			//console.log("rowIndex : " + event.rowIndex + ", columnIndex : " + event.columnIndex + " clicked");			
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
			fn_getOrgCdListAllAjax(); //call orgList
		});		
			
		//조회
	$("#search").click(function(){	
		   Common.ajax("GET", "/commission/system/selectRuleBookItemMngList", $("#searchForm").serialize(), function(result) {
			     
			      console.log("성공.");
			      console.log("data : " + result);
			      AUIGrid.setGridData(myGridID, result);
			    });
   });
		
	//rule 조회
	$("#searchRule").click(function() {
			$("#searchFormRule [name=ruleSeq]").val("");
			Common.ajax("GET", "/commission/system/selectRuleBookMngList", $("#searchFormRule").serialize(), function(result) {
				console.log("성공.");
				console.log("data : " + result);			
				AUIGrid.setGridData(myGridID2, result);
				//category 동적 생성
				 $("#category").empty();         
			 	if (result.length>0) {
					for (var i = 0; i < result.length; i++) {
						var obj = result[i];
						if(i==0 || obj.ruleLevel != result[i-1].ruleLevel){
							$("#category").append("<ul id='ul"+obj.ruleLevel+"' /> ");
						}
						$("#ul"+obj.ruleLevel).append("<li><strong>"+obj.ruleCategory+"</strong><p>"+obj.resultValue+"</p></li>");
					}
					 $("#searchFormRule [name=valueTypeNm]").val(result[0].valueTypeNm);
					 $("#searchFormRule [name=valueType]").val(result[0].valueType);
					 $("#searchFormRule [name=resultValueNm]").val(result[0].resultValueNm);
				} 
			});
		});

		//close
		$("#close01").click(function() {
			$("#searchFormRule")[0].reset();
			$("#popup_wrap").hide();
			$("#category").empty();
			AUIGrid.clearGridData(myGridID2);  //grid data clear
		});

		//close
		$("#close02").click(function() {
			$("#insertFormRule")[0].reset();
			$("#popup_wrap2").hide();
		});

		//아이템 저장
		$("#save").click(function() {
			if (validation()) {
				Common.ajax("POST", "/commission/system/saveCommissionItemGrid.do", GridCommon.getEditData(myGridID), function(result) {
					// 공통 메세지 영역에 메세지 표시.
					Common.setMsg("<spring:message code='sys.msg.success'/>");
					$("#search").trigger("click");
				}, function(jqXHR, textStatus, errorThrown) {
					try {
						console.log("status : " + jqXHR.status);
						console.log("code : " + jqXHR.responseJSON.code);
						console.log("message : " + jqXHR.responseJSON.message);
						console.log("detailMessage : " + jqXHR.responseJSON.detailMessage);
					} catch (e) {
						console.log(e);
					}
					alert("Fail : " + jqXHR.responseJSON.message);
					fn_getSampleListAjax();
				});
			}
		});

		//아이템 grid 행 추가
		$("#addRow").click(function() {
			var item = new Object();
			item.orgSeq = "";
			item.orgGrCd = "";
			item.itemSeq = "";
			item.orgCd = "Please select";
			item.orgDs = "";
			item.itemCd = "Please select";
			item.cdDs = "";
			item.useYn = "Y";
			item.typeCd = "1";
			item.endDt = "";

			// parameter
			// item : 삽입하고자 하는 아이템 Object 또는 배열(배열인 경우 다수가 삽입됨)
			// rowPos : rowIndex 인 경우 해당 index 에 삽입, first : 최상단, last : 최하단, selectionUp : 선택된 곳 위, selectionDown : 선택된 곳 아래
			AUIGrid.addRow(myGridID, item, "first");
		});

		//rule 등록 및 수정 팝업
		$("#addRule").click(function() {
			$("#insertFormRule")[0].reset();
			var checkedItems = AUIGrid.getCheckedRowItems(myGridID2);
			var str = "";
			var rowItem;			
			var len = checkedItems.length;
			rowItem = checkedItems[0];
			console.log($("#searchFormRule [name=itemCd]").val());
			console.log($("#searchFormRule [name=itemSeq]").val());
			console.log($("#searchFormRule [name=orgSeq]").val());
			if (len > 0) {
				$("#searchFormRule [name=ruleSeq]").val(rowItem.item.ruleSeq);
			}
			Common.ajax("GET", "/commission/system/selectRuleBookMngList", $("#searchFormRule").serialize(), function(result) {
				console.log("성공.");
				console.log("data : " + result);
				//to-do list 1.div show(),신규인지 하위등록 인지 체크 , 조회값 셋팅
				$("#popup_wrap2").show();

				//data set
				$("#insertFormRule [name=saveType]").val("I");
				if (len <= 0) {
					$("#insertFormRule [name=ruleLevel]").val("1");
					$("#insertFormRule [name=rulePid]").val("0");
				} else {
					str += "row : " + rowItem.rowIndex + ", id :" + rowItem.item.id + ", name : " + rowItem.item.name + "\n";
					console.log("str===" + str);
					$("#insertFormRule [name=ruleLevel]").val(parseInt(rowItem.item.ruleLevel, 10) + 1);
					$("#insertFormRule [name=rulePid]").val(rowItem.item.ruleSeq);
				}
				$("#insertFormRule [name=orgDs]").val($("#searchFormRule [name=orgNm]").val());
				$("#insertFormRule [name=codeName]").val($("#searchFormRule [name=itemNm]").val());
				$("#insertFormRule [name=itemCd]").val($("#searchFormRule [name=itemCd]").val());
				$("#insertFormRule [name=itemSeq]").val($("#searchFormRule [name=itemSeq]").val());
			//	$("#insertFormRule [name=orgSeq]").val($("#searchFormRule [name=orgSeq]").val());
			});
		}); // addrule     

		//rule 수정 팝업
		$("#editRule").click(function() {
			$("#insertFormRule")[0].reset();
			var checkedItems = AUIGrid.getCheckedRowItems(myGridID2);
			var str = "";
			var rowItem;
			var len = checkedItems.length;
			if (len <= 0) {
				Common.alert("Plese Check Radio Box");
				return false;
			}
			rowItem = checkedItems[0];
			str += "row : " + rowItem.rowIndex + ", id :" + rowItem.item.id + ", name : " + rowItem.item.name + "\n";
			$("#searchFormRule [name=ruleSeq]").val(rowItem.item.ruleSeq);

			Common.ajax("GET", "/commission/system/selectRuleBookMngList", $("#searchFormRule").serialize(), function(result) {
				console.log("성공.");
				console.log("data : " + result);
				//to-do list 1.div show(),신규인지 하위등록 인지 체크 , 조회값 셋팅
				$("#popup_wrap2").show();

				//data set

				console.log("str===" + str);
				Common.setData(result[0], $("#insertFormRule"));
				if(result[0].rulePid==null ||result[0].rulePid==""){
					$("#insertFormRule [name=rulePid]").val("0");
				}
				
				$("#insertFormRule [name=saveType]").val("U");

			});

		}); //editRule

		//rule 저장
		$("#saveRule").click(function() {
			if (validationForm($("#insertFormRule"))) {
				Common.ajax("POST", "/commission/system/saveCommissionRule.do", $("#insertFormRule").serializeJSON(), function(result) {
					//Common.ajax("GET", "/commission/system/saveCommissionItemGrid.do", GridCommon.getEditData(myGridID), function(result) {      
					// 공통 메세지 영역에 메세지 표시.
					Common.alert("<spring:message code='sys.msg.success'/>");
					$("#searchRule").trigger("click");
					$("#close02").trigger("click");
				}, function(jqXHR, textStatus, errorThrown) {
					try {
						console.log("status : " + jqXHR.status);
						console.log("code : " + jqXHR.responseJSON.code);
						console.log("message : " + jqXHR.responseJSON.message);
						console.log("detailMessage : " + jqXHR.responseJSON.detailMessage);
					} catch (e) {
						console.log(e);
					}
					alert("Fail : " + jqXHR.responseJSON.message);
					fn_getSampleListAjax();
				});
			}
		});

	});//Ready

	//event management
	function auiCellEditingHandler(event) {
		if (event.type == "cellEditEnd") {
			if (event.columnIndex == 3) {
				var val = event.value;
				var data = getOrgCdData(val);
				AUIGrid.setCellValue(myGridID, event.rowIndex, event.columnIndex - 3, data.split(",")[0]);
				AUIGrid.setCellValue(myGridID, event.rowIndex, event.columnIndex - 2, data.split(",")[1]);
				AUIGrid.setCellValue(myGridID, event.rowIndex, event.columnIndex + 1, data.split(",")[4]);
				AUIGrid.setCellValue(myGridID, event.rowIndex, event.columnIndex + 8, data.split(",")[3]);
			} else if (event.columnIndex == 5) {
				var val = event.value;
				var data = getOrgItemData(val);
				//	AUIGrid.setCellValue(myGridID, event.rowIndex, event.columnIndex - 2, "");
				AUIGrid.setCellValue(myGridID, event.rowIndex, event.columnIndex + 1, data.split(",")[2]);
				AUIGrid.setCellValue(myGridID, event.rowIndex, event.columnIndex + 7, data.split(",")[1]);
			} else if (event.columnIndex == 8) { //use_yn
				var val = event.value;
				if (val == "") {
					AUIGrid.setCellValue(myGridID, event.rowIndex, event.columnIndex, "Y");
				}

			} else if (event.columnIndex == 9) { //level
				var val = event.value;
				if (val == "") {
					AUIGrid.setCellValue(myGridID, event.rowIndex, event.columnIndex, "1");
				}
			}
		} else if (event.type == "cellEditBegin") {
			var itemSeq = AUIGrid.getCellValue(myGridID, event.rowIndex, 2);
			if (!AUIGrid.isAddedById(myGridID, itemSeq) && event.columnIndex != 8 && event.columnIndex != 9) {
				return false;
			}
			if (event.columnIndex == 5) {
				var val = AUIGrid.getCellValue(myGridID, event.rowIndex, event.columnIndex - 2);
				if (val == null || val == "" || val == "Please select") {
					alert("Please select ORG CD");
					return false;
				}
			}
		}

	}

	//그리드 그룹 리스트
	function getOrgCdData(val) {
		var retStr = "";
		$.each(orgGridCdList, function(key, value) {
			var id = value.id;
			if (id == val) {
				retStr = value.orgSeq + "," + value.orgGrCd + "," + value.id + "," + value.value + "," + value.cdDs;
			}
		});
		return retStr;
	}

	//그리드 아이템 리스트
	function getOrgItemData(val) {
		var retStr = "";
		$.each(orgItemList, function(key, value) {
			var id = value.id;
			if (id == val) {
				retStr = value.id + "," + value.value + "," + value.cdNm + "," + value.cdDs;
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

	//item list search
	function getOrgRgCodeItemList(callBack) {
		Common.ajaxSync("GET", "/commission/system/selectOrgItemList", $("#searchForm").serialize(), function(result) {
			orgItemList = new Array();
			for (var i = 0; i < result.length; i++) {
				var list = new Object();
				list.id = result[i].codeId;
				list.value = result[i].code;
				list.cdNm = result[i].codeName;
				list.cdDs = result[i].cdDs;
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

	// 아이템 AUIGrid 칼럼 설정
	var columnLayout = [ {
		dataField : "orgSeq",
		headerText : "ORG SEQ",
		visible : false
	}, {
		dataField : "orgGrCd",
		headerText : "ORG GR CD",
		width : 120,
		visible : false
	}, {
		dataField : "itemSeq",
		headerText : "ITEM SEQ",
		width : 120,
		visible : false
	}, {
		dataField : "orgCd",
		headerText : "ORG CD",
		width : 120,
		editRenderer : {
			type : "ComboBoxRenderer",
			showEditorBtnOver : true, // 마우스 오버 시 에디터버턴 보이기
			listFunction : function(rowIndex, columnIndex, item, dataField) {
				fn_getOrgCodeListAjax();
				return orgGridCdList;
			},
			keyField : "id",
			valueField : "value",
		}
	}, {
		dataField : "orgDs",
		headerText : "ORG NAME",
		width : 200,
		style : "my-column",
	}, {
		dataField : "itemCd",
		headerText : "ITEM CODE",
		width : 120,
		editRenderer : {
			type : "ComboBoxRenderer",
			showEditorBtnOver : true, // 마우스 오버 시 에디터버턴 보이기
			listFunction : function(rowIndex, columnIndex, item, dataField) {
				$("#ItemOrgCd").val(item.orgNm);
				var list = getOrgRgCodeItemList();
				return list;
			},
			keyField : "id",
			valueField : "value"
		}
	}, {
		dataField : "codeName",
		headerText : "Description",
		editable : false,
		style : "my-column",
		width : 300
	}, {
		dataField : "editBtn",
		headerText : "Management<br>RULE",
		width : 120,
		renderer : {
			type : "ButtonRenderer",
			labelText : "EDIT",
			onclick : function(rowIndex, columnIndex, value, item) {
				$("#popup_wrap").show();

				console.log("itemCd : " + AUIGrid.getCellValue(myGridID, rowIndex, 5));
				console.log("itemSeq : " + AUIGrid.getCellValue(myGridID, rowIndex, 0));
				console.log("orgSeq : " + AUIGrid.getCellValue(myGridID, rowIndex, 2));
				$("#searchFormRule [name=itemCd]").val(AUIGrid.getCellValue(myGridID, rowIndex, 5));
				$("#searchFormRule [name=itemSeq]").val(AUIGrid.getCellValue(myGridID, rowIndex, 2));
				$("#searchFormRule [name=orgSeq]").val(AUIGrid.getCellValue(myGridID, rowIndex, 0));
				$("#searchFormRule [name=orgNm]").val(AUIGrid.getCellValue(myGridID, rowIndex, 4));
				$("#searchFormRule [name=itemNm]").val(AUIGrid.getCellValue(myGridID, rowIndex, 6));

				//mygridid2 option
				var options = {
					// 체크박스 표시 설정
					showRowCheckColumn : true,
					// 체크박스 대신 라디오버튼 출력함
					rowCheckToRadio : true,
					// 엑스트라 라디오 버턴 체커블 함수
					// 이 함수는 사용자가 라디오를 클릭 할 때 1번 호출됩니다.
			/* 		rowCheckableFunction : function(rowIndex, isChecked, item) {
						if (item.product == "LG G3") { // 제품이 LG G3 인 경우 사용자 체크 못하게 함.
							return false;
						}
						return true;
					}, */
					selectionMode : "singleRow",
					displayTreeOpen : true,
					// 일반 데이터를 트리로 표현할지 여부(treeIdField, treeIdRefField 설정 필수)
					rowIdField : "ruleSeq",
				  flat2tree : true,
				  // 트리의 고유 필드명
			    treeIdField : "ruleSeq",
			     // 계층 구조에서 내 부모 행의 treeIdField 참고 필드명
			     treeIdRefField : "rulePid"
				};
				if(!myGridID2){
					myGridID2= GridCommon.createAUIGrid("grid_wrap2", columnLayout2, "ruleSeq", options);
				}
				// 체크박스 클린 이벤트 바인딩
				AUIGrid.bind(myGridID2, "rowCheckClick", function(event) {
					alert("rowIndex : " + event.rowIndex + ", id : " + event.item.id + ", name : " + event.item.name + ", checked : " + event.checked);
				});
				
				$("#searchRule").trigger("click");
				
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
		dataField : "typeCd",
		headerText : "Level",
		width : 120,
		editRenderer : {
			type : "InputEditRenderer",
			showEditorBtnOver : true, // 마우스 오버 시 에디터버턴 보이기
			onlyNumeric : true, // 0~9만 입력가능
			allowPoint : false, // 소수점( . ) 도 허용할지 여부
			allowNegative : false, // 마이너스 부호(-) 허용 여부
			textAlign : "right", // 오른쪽 정렬로 입력되도록 설정
			maxlength : 1,
			autoThousandSeparator : false
		// 천단위 구분자 삽입 여부

		}
	}, {
		dataField : "endDt",
		headerText : "END DATE",
		editable : false,
		width : 120
	}, {
		dataField : "orgNm",
		headerText : "ORG Name",
		visible : false,
	}, {
		dataField : "itemNm",
		headerText : "Item Name",
		visible : false,
	} ];

	/**********************
	 rule AUIGrid 칼럼 설정
	**********************/
	var columnLayout2 = [   {
	    dataField : "orgDs",
	    headerText : "ORG Name",
	    width : 120,
	    style : "my-column",
	  } ,{
		dataField : "orgSeq",
		headerText : "ORG SEQ",
		visible : false
	}, {
		dataField : "itemSeq",
		headerText : "ITEM SEQ",
		visible : false
	},  {
		dataField : "ruleSeq",
		headerText : "RULE SEQ",
		visible : false
	} , {
		dataField : "ruleLevel",
		headerText : "RULE Level",
		visible : false
	}, {
		dataField : "ruleCategory",
		headerText : "RULE CATEGORY",
		width : 200,
		style : "my-column",
	}, {
		dataField : "ruleOpt1",
		headerText : "Range Start Value",
		width : 100,
	}, {
		dataField : "ruleOpt2",
		headerText : "Range End Value",
		width : 100,
	}, {
		dataField : "valueType",
		headerText : "Range Value Type",
		width : 100,
	}, {
		dataField : "resultValue",
		headerText : "Conditional Value",
		width : 100,
	}, {
		dataField : "resultValueNm",
		headerText : "Condition Value Type",
		width : 100,
	}, {
		dataField : "startDt",
		headerText : "Start Month/Year",
		width : 100,
	}, {
		dataField : "endDt",
		headerText : "End Month/Year",
		width : 100,
	}, {
		dataField : "useYn",
		headerText : "USE(Y/N)",
		width : 100,
	}, {
	    dataField : "rulePid",
	    headerText : "Rule Parent ID",
	    visible : false,
	  }  ];

	//get Ajax data and set organization combo data

	function fn_getOrgCdListAllAjax(callBack) {
		Common.ajaxSync("GET", "/commission/system/selectOrgCdListAll", $("#searchForm").serialize(), function(result) {
			orgList = new Array();
			if (result) {
				$("#orgCombo").append("<option value='' ></option>");
				for (var i = 0; i < result.length; i++) {
					$("#orgCombo").append("<option value='"+result[i].orgCd + "' > " + result[i].orgNm + "</option>");
				}
			}
			//if you need callBack Function , you can use that function
			if (callBack) {
				callBack(orgList);
			}
		});
	}

	//In grid orgCdList 
	function fn_getOrgCodeListAjax(callBack) {
		Common.ajaxSync("GET", "/commission/system/selectOrgCdList", $("#searchForm").serialize(), function(result) {
			orgGridCdList = new Array();
			for (var i = 0; i < result.length; i++) {
				var list = new Object();
				list.id = result[i].orgCd;
				list.value = result[i].orgNm;
				list.cdDs = result[i].cdDs;
				list.orgSeq = result[i].orgSeq;
				list.orgGrCd = result[i].orgGrCd;
				orgGridCdList.push(list);
			}
			if (callBack) {
				//   callBack(orgList);
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

	//Save Data
	function fn_saveGridMap() {
		if (validation()) {
			Common.ajax("POST", "/commission/system/saveCommissionItemGrid.do", GridCommon.getEditData(myGridID), function(result) {
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
				alert("Fail : " + jqXHR.responseJSON.message);
				fn_getSampleListAjax();
			});
		}
	}

	/*  validation */
	function validationForm($form) {
		var retVal= true;
		var $input = $($form).find("input:text,select,radio,textarea");
		$.each($input, function(index, elem) {
			var name = $(this).attr("name");
			var val = $(this).val();
			if (val == null || val == "") {
				if ($(this).attr("placeholder")) {
					name = $(this).attr("placeholder");
				}
				Common.alert(name + ":EMPTY DATA");
				retVal=false;
				return false;
			}
		});
		return retVal;
	}

	 /*  validation */
	function validation() {
		var result = true;
		var addList = AUIGrid.getAddedRowItems(myGridID);
		var udtList = AUIGrid.getEditedRowItems(myGridID);
		if (addList.length == 0 && udtList.length == 0) {
			alert("Please add or edit!");
			return false;
		}

		for (var i = 0; i < addList.length; i++) {
			var orgSeq = addList[i].orgSeq;
			var orgGrCd = addList[i].orgGrCd;
			var orgCd = addList[i].orgCd;
			var itemCd = addList[i].itemCd;
			var useYn = addList[i].useYn;
			var typeCd = addList[i].typeCd;
			if (orgCd == "") {
				result = false;
				alert("Please select ORG CODE!");
				break;
			} else if (itemCd == "") {
				result = false;
				alert("Please select ITEM CODE!");
				break;
			} else if (useYn == "") {
				result = false;
				alert("Please select USE YN!");
				break;
			} else if (typeCd == "") {
				result = false;
				alert("Please entry TYPE CODE!");
				break;
			}
		}
		for (var i = 0; i < udtList.length; i++) {
			var orgSeq = udtList[i].orgSeq;
			var orgGrCd = udtList[i].orgGrCd;
			var orgCd = udtList[i].orgCd;
			var itemCd = udtList[i].itemCd;
			var useYn = udtList[i].useYn;
			var typeCd = udtList[i].typeCd;
			if (orgCd == "") {
				result = false;
				alert("Please select ORG CODE!");
				break;
			} else if (itemCd == "") {
				result = false;
				alert("Please select ITEM CODE!");
				break;
			} else if (useYn == "") {
				result = false;
				alert("Please select USE YN!");
				break;
			} else if (typeCd == "") {
				result = false;
				alert("Please entry TYPE CODE!");
				break;
			}
		}
		return result;
	}

	// 체크된 아이템 얻기
	function getCheckedRowItems() {
		var checkedItems = AUIGrid.getCheckedRowItems(myGridID2);
		var str = "";
		var rowItem;
		var len = checkedItems.length;

		if (len <= 0) {
			alert("체크된 행 없음!!");
			return;
		}

		for (var i = 0; i < len; i++) {
			rowItem = checkedItems[i];
			str += "row : " + rowItem.rowIndex + ", id :" + rowItem.item.id + ", name : " + rowItem.item.name + "\n";
		}
		alert(str);
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
					<a href="#"  id="search" ><span class="search"></span>Search</a>
				</p></li>
		</ul>

	</aside>
	<!-- title_line end -->

	<section class="search_table">
		<!-- search_table start -->
		<form id="searchForm" action="" method="post">
      <input type="hidden" id="ItemOrgCd" name="ItemOrgCd"/>
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
						<td><input type="text" id="searchDt" name="searchDt" title="Month/Year" class="j_date2" value="${searchDt }" style="width: 200px;" /></td>
						<th scope="row">ORG Group</th>
						<td><select id="orgRgCombo" name="orgRgCombo" style="width: 100px;">
								<option value=""></option>
								<c:forEach var="list" items="${orgGrList }">
									<option value="${list.orgGrCd}">${list.orgGrNm}</option>
								</c:forEach>
						</select></td>
						<th scope="row">ORG Code</th>
						<td><select id="orgCombo" name="orgCombo" style="width: 100px;">
								<option value=""></option>
								<c:forEach var="list" items="${orgList }">
									<option value="${list.orgCd}">${list.orgNm}</option>
								</c:forEach>
						</select></td>					
						<input type="hidden" id="orgGrCd" name="orgGrCd" value="">
						<th scope="row">USE YN</th>
						<td><select id="useYnCombo" name="useYnCombo" style="width: 100px;">
								<option value=""></option>
								<option value="Y">Y</option>
								<option value="N">N</option>
						</select></td>
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
			<li><p class="btn_grid">
					<a href="#" id="addRow"><span class="search"></span>ADD</a> <a href="#" id="save">Save</a>
				</p></li>
		</ul>

		<article class="grid_wrap">
			<!-- grid_wrap start -->
			<div id="grid_wrap" style="width: 100%; height: 500px; margin: 0 auto;"></div>
		</article>
		<!-- grid_wrap end -->

	</section>
	<aside class="bottom_msg_box">
		<!-- bottom_msg_box start -->
		<p></p>
	</aside>
	<!-- bottom_msg_box end -->
	<!-- search_result end -->

</section>
<!-- content end -->

</section>
<!-- container end -->
<hr />

</div>
<!-- wrap end -->

<!-- ================================================================================================ rule book 조회 시작 ================ -->
<div id="popup_wrap" style="display:none;"><!-- popup_wrap start -->

<header class="pop_header"><!-- pop_header start -->
<h1>Commission Rule Book Mgmt</h1>
<ul class="right_opt">
  <li><p class="btn_blue2"><a href="#" id="close01">CLOSE</a></p></li>
</ul>
</header><!-- pop_header end -->

<section class="pop_body"><!-- pop_body start -->
<form id="searchFormRule" action="" method="post">
<input type="hidden" name="itemCd" id="itemCd"/>
<input type="hidden" name="itemSeq" id="itemSeq"/>
<input type="hidden" name="orgSeq" id="orgSeq"/>
<input type="hidden" name="ruleSeq" id="ruleSeq"/>

<ul class="right_btns">
  <li><p class="btn_blue"><a href="#" id="searchRule"><span class="search"></span>Search</a></p></li>
</ul>

<table class="type1 mt10"><!-- table start -->
<caption>table</caption>
<colgroup>
  <col style="width:130px" />
  <col style="width:200px" />
  <col style="width:130px" />
  <col style="width:*" />
</colgroup>
<tbody>
<tr>
  <th scope="row">Month/Year</th>
  <td>
  <input type="text" title="Create start Date" placeholder="DD/MM/YYYY" name="searchDt" class="j_date2" value="${searchDt }" />
  </td>
  <th scope="row">USE YN</th>
  <td>
  <select>
    <option value=""></option>
    <option value="Y">Y</option>
    <option value="N">N</option>
  </select>
  <label><input type="radio" name="use_yn" /><span>Actual</span></label>
  <label><input type="radio" name="use_yn" /><span>Simulation</span></label>
  </td>
</tr>
</tbody>
</table><!-- table end -->

<section class="search_result"><!-- search_result start -->

<article id="category" class="award_wrap"><!-- award_wrap start -->
</article><!-- award_wrap end -->

<aside class="title_line"><!-- title_line start -->
<h2>Rule Information & Edit</h2>
</aside><!-- title_line end -->

<table class="type1 mt10"><!-- table start -->
<caption>table</caption>
<colgroup>
  <col style="width:180px" />
  <col style="width:*" />
</colgroup>
<tbody>
<tr>
  <th scope="row">ORG NAME</th>
  <td>
  <input type="text" title="" placeholder="Org Name" class="readonly w100p" id="orgNm" name="orgNm" readonly="readonly" />
  </td>
</tr>
<tr>
  <th scope="row">Title</th>
  <td>
  <input type="text" title="" placeholder="Performance Evaluation Awards" class="readonly w100p"  id="itemNm" name="itemNm" readonly="readonly" />
  </td>
</tr>
<tr>
  <th scope="row">Range Value Name</th>
  <td>
  <input type="text" title="" placeholder="Performance Evaluation Rank" class="w100p"  id="valueTypeNm" name="valueTypeNm" />
  </td>
</tr>
<tr>
  <th scope="row">Range value type</th>
  <td>
  <input type="text" title="" placeholder="RANK" class="w100p" id="valueType" name="valueType" />
  </td>
</tr>
<tr>
  <th scope="row">Conditional Result Value Name</th>
  <td>
  <input type="text" title="" placeholder="AMOUNT(RM)" class="w100p"  id="resultValueNm" name="resultValueNm" />
  </td>
</tr>
</tbody>
</table><!-- table end -->

<ul class="right_btns">
  <li><p class="btn_grid"><a href="#" id="addRule">ADD</a></p></li>
  <li><p class="btn_grid"><a href="#" id="editRule">EDIT</a></p></li>
  <!-- <li><p class="btn_grid"><a href="#">저장</a></p></li> -->
</ul>

<article class="grid_wrap2"><!-- grid_wrap start -->
  <!-- grid_wrap start -->
      <div id="grid_wrap2" style="width: 100%; height: 500px; margin: 0 auto;"></div>
</article><!-- grid_wrap end -->

</section><!-- search_result end -->
</form>
</section><!-- pop_body end -->

</div><!-- popup_wrap end -->
<!-- ================ rule book 조회 끝 ================ -->


<!-- ================================================================================================ rule book 등록 시작 ================ -->
<div id="popup_wrap2" style="display:none;" class="popup_wrap"><!-- popup_wrap start -->

<header class="pop_header"><!-- pop_header start -->
<h1>Commission Rule Book Mgmt</h1>
<ul class="right_opt">
  <li><p class="btn_blue2"><a href="#" id="close02">CLOSE</a></p></li>
</ul>
</header><!-- pop_header end -->

<section class="pop_body"><!-- pop_body start -->
<form id="insertFormRule" action="" method="post">
<input type="hidden" name="itemSeq" />
<input type="hidden" name="itemCd" />
<input type="hidden" name="ruleSeq" />
<input type="hidden" name="ruleLevel" />
<input type="hidden" name="rulePid" />
<input type="hidden" name="saveType" />

<table class="type1"><!-- table start -->
<caption>table</caption>
<colgroup>
  <col style="width:160px" />
  <col style="width:*" />
  <col style="width:210px" />
  <col style="width:*" />
</colgroup>
<tbody>
<tr>
  <th scope="row">ORG Name</th>
  <td colspan="3"><input type="text" title="" placeholder="OGR Name" class="readonly w100p" id="orgDs" name="orgDs" readonly="readonly" /></td>  
</tr>
<tr>
  <th scope="row">Item Name</th>
  <td colspan="3"><input type="text" title="" placeholder="Item Name" class="readonly w100p" id="codeName" name="codeName" readonly="readonly" /></td>
</tr>
<tr>
  <th scope="row">Rule Name</th>
  <td><input type="text" title="" placeholder="Rule Name" class="w100p" id="ruleNm" name="ruleNm" /></td>
  <th scope="row">USE (Y/N)</th>
  <td>
  <select class="w10p" id="useYn" name="useYn">
    <option value="Y">Y</option>
    <option value="N">N</option>
  </select>
  </td>
</tr>
<tr>
  <th scope="row">Rule Category</th>
  <td colspan="3"><input type="text" title="" placeholder="Rule Category" class="w100p" id="ruleCategory" name="ruleCategory"  /></td>
</tr>
<tr>
  <th scope="row">Range Start Value</th>
  <td><input type="text" title="" placeholder="Range Start Value" class="w100p" id="ruleOpt1" name="ruleOpt1"  /></td>
  <th scope="row">Range End Value</th>
  <td><input type="text" title="" placeholder="Range End Value" class="w100p" id="ruleOpt2" name="ruleOpt2"  /></td>
</tr>
<tr>
  <th scope="row">Range Value Type</th>
  <td><input type="text" title="" placeholder="Range Value Type" class="w100p" id="valueType" name="valueType"  /></td>
  <th scope="row">Range Value Type Name</th>
  <td><input type="text" title="" placeholder="Range Value Type Name" class="w100p" id="valueTypeNm" name="valueTypeNm"  /></td>
</tr>
<tr>
  <th scope="row">Result Value </th>
  <td><input type="text" title="" placeholder="Result Value" class="w100p" id="resultValue" name="resultValue"  /></td>
  <th scope="row">Result Value  Name</th>
  <td><input type="text" title="" placeholder="Result Vallue  Name" class="w100p" id="resultValueNm" name="resultValueNm"  /></td>
</tr>
<tr>
  <th scope="row">Description</th>
  <td colspan="3">
    <textarea cols="40" rows="5"  id="ruleDesc" name="ruleDesc" placeholder="Rule Description" ></textarea>
  </td>
</tr>
</tbody>
</table><!-- table end -->

<ul class="right_btns">
  <li><p class="btn_grid"><a href="#" id="saveRule">Save</a></p></li>
</ul>
</form>
</section><!-- pop_body end -->

</div><!-- popup_wrap end -->
<!-- ================ rule book 등록 끝 ================ -->


</body>
</html>



