<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>

<style type="text/css">

/* 커스텀 칼럼 스타일 정의 */
.my-column {
	text-align: left;
	margin-top: -20px;
}
/* gride 동적 버튼 */
.edit-column {
    visibility:hidden;
}
</style>

<script type="text/javaScript">

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
		
		//drag div
		$("#popup_wrap, .popup_wrap").draggable({handle: '.pop_header'});
		$("#popup_wrap2, .popup_wrap2").draggable({handle: '.pop_header'});
		
		// AUIGrid 그리드를 생성합니다.
		myGridID = GridCommon.createAUIGrid("grid_wrap", columnLayout,"itemSeq");

		// cellClick event.
		AUIGrid.bind(myGridID, "cellClick", function(event) {
			console.log("rowIndex : " + event.rowIndex + ", columnIndex : " + event.columnIndex + " clicked");			
		});		
		
		AUIGrid.bind(myGridID, "cellEditBegin", auiCellEditingHandler);      // 에디팅 시작 이벤트 바인딩
		AUIGrid.bind(myGridID, "cellEditEnd", auiCellEditingHandler);        // 에디팅 정상 종료 이벤트 바인딩
		AUIGrid.bind(myGridID, "cellEditCancel", auiCellEditingHandler);    // 에디팅 취소 이벤트 바인딩
		AUIGrid.bind(myGridID, "addRow", auiAddRowHandler);               // 행 추가 이벤트 바인딩 
		AUIGrid.bind(myGridID, "removeRow", auiRemoveRowHandler);     // 행 삭제 이벤트 바인딩 
		
		//Rule Book Item search
		$("#search").click(function(){	
			Common.ajax("GET", "/commission/system/selectRuleBookItemMngList", $("#searchForm").serialize(), function(result) {
				console.log("성공.");
				console.log("data : " + result);
				AUIGrid.setGridData(myGridID, result);
			});
	   });

        //Rule Book Item save
        $("#save").click(function() {
            if (validation()) {
                Common.confirm("<spring:message code='sys.common.alert.save'/>",fn_saveGridCall);
            }
        });

		//아이템 grid 행 추가
		$("#addRow").click(function() {
			var item = new Object();
			item.orgSeq = "";
			item.orgGrCd = "";
			item.itemSeq = "";
			item.orgCd = "<spring:message code='sys.info.grid.selectMessage'/>";
			item.orgDs = "";
			item.itemCd = "<spring:message code='sys.info.grid.selectMessage'/>";
			item.cdDs = "";
			item.useYn = "Y";
			item.typeCd = "1";
			item.endDt = "";

			// parameter
			// item : 삽입하고자 하는 아이템 Object 또는 배열(배열인 경우 다수가 삽입됨)
			// rowPos : rowIndex 인 경우 해당 index 에 삽입, first : 최상단, last : 최하단, selectionUp : 선택된 곳 위, selectionDown : 선택된 곳 아래
			AUIGrid.addRow(myGridID, item, "first");
		});
		
//********************************************
//Commission Rule Book Mgmt Script Ready
//********************************************
		//close
        $("#close01").click(function() {
            $("#searchFormRule")[0].reset();
              $("#popup_wrap").hide();
              $("#category").empty();
              AUIGrid.clearGridData(myGridID2);  //grid data clear
        }); 
        
      //rule search
       $("#searchRule").click(function() {
            $("#searchFormRule [name=ruleSeq]").val("");
            Common.ajax("GET", "/commission/system/selectRuleBookMngList", $("#searchFormRule").serialize(), function(result) {
                console.log("성공.");
                console.log("data : " + result);            
                console.log("result.length : " + result.length);            
                AUIGrid.setGridData(myGridID2, result);
                
                //category 동적 생성
                 $("#category").empty();        
                
                if (result.length>0) {
                	
	                var levCnt=0;
                	var categoryTmp = "";
                	
	                for (var i = 0; i < result.length; i++) {
	                	var obj = result[i];
	                	if(i==0 || obj.ruleLevel == 1){
	                		categoryTmp = categoryTmp+ "<table id='lev_"+obj.ruleLevel+"' class='type2 gray'>";
                            categoryTmp = categoryTmp+ " <caption>table</caption>";
                            categoryTmp = categoryTmp+ " <thead>";
                            categoryTmp = categoryTmp+ "     <tr id='thead_"+obj.ruleLevel+"' />";
                            categoryTmp = categoryTmp+ " </thead>";
                            categoryTmp = categoryTmp+ " <tbody>";
                            categoryTmp = categoryTmp+ "     <tr id='tbody_"+obj.ruleLevel+"' />";
                            categoryTmp = categoryTmp+ " </tbody>";
                            categoryTmp = categoryTmp+ "</table>";
                            $("#category").append(categoryTmp);
	                	}
	                	$("#thead_"+obj.ruleLevel).append("<th scope='col'>"+obj.ruleCategory+"</th>");
                        $("#tbody_"+obj.ruleLevel).append("<td><span>"+obj.resultValue+"</span></td>");
                        if(obj.ruleLevel > 1){
                        	levCnt = Number(levCnt)+1;
                        }
	                }
	                
	                if(Number(levCnt) > 0){
	                	for(var i = 0; i < result.length; i++){
	                		if(result[i].ruleLevel == 1){
	                			categoryTmp = categoryTmp+ "<br>";
	                			categoryTmp = categoryTmp+ "<table id='lev_2_"+result[i].ruleSeq+"' class='type2 gray'>";
	                			categoryTmp = categoryTmp+ "   <thead>";
	                			categoryTmp = categoryTmp+ "     <tr id='thead_2_"+result[i].ruleSeq+"'>";
	                			categoryTmp = categoryTmp+ "        <td scope='col' rowspan=2 align='center' valign='bottom'  style='font-weight: bold; background: #eee;'>"+result[i].ruleCategory+"</td>";
	                			categoryTmp = categoryTmp+ "     </tr>";
	                			categoryTmp = categoryTmp+ "   </thead>";
	                			categoryTmp = categoryTmp+ "        <tr id='tbody_2_"+result[i].ruleSeq+"'>";
	                			categoryTmp = categoryTmp+ "            <td style='background: #eee'> </td>";
	                			categoryTmp = categoryTmp+ "        </tr>";
	                            categoryTmp = categoryTmp+ "   <tbody>";
	                            categoryTmp = categoryTmp+ "   </tbody>";
	                			categoryTmp = categoryTmp+ "</table>";
	                		}
	                	}
	                	$("#category").append(categoryTmp);
	                	
	                	for(var i = 0; i < result.length; i++){
	                		//if(result[i].ruleLevel == 1){
	                			
		                		for(var j=0 ; j<result.length; j++){
		                			//console.log(result[i].ruleSeq);
		                			
			                		 if(result[i].ruleSeq == result[j].rulePid){
			                			 if(result[j].ruleLevel == 2){
					                		$("#thead_2_"+result[i].ruleSeq).append("<th scope='col' id='th_"+result[j].ruleSeq+"'>"+result[j].ruleCategory+"</th>");
					                		$("#tbody_2_"+result[i].ruleSeq).append("<td id='td_"+result[j].ruleSeq+"'><span>"+result[j].resultValue+"</span></td>");
			                			 }else if(result[j].ruleLevel > 2){
			                				 var thParent = $("#th_"+result[i].ruleSeq+"").parent().attr("id");
			                				 var tdParent = $("#td_"+result[i].ruleSeq+"").parent().attr("id");
			                				 console.log("parent : " + $("#th_"+result[i].ruleSeq+"").parent().attr("id"));
			                				 $("#"+thParent).append("<th scope='col' id='th_"+result[j].ruleSeq+"'>"+result[j].ruleCategory+"</th>");
	                                         $("#"+tdParent).append("<td id='td_"+result[j].ruleSeq+"'><span>"+result[j].resultValue+"</span></td>");
			                			 }
			                		}//if
			                		
		                		}//j
		                		
	                		//}//if
	                	}//i
	                }
	                
	                
	                
                    /* for (var i = 0; i < result.length; i++) {
                        var obj = result[i];
                        if(i==0 || obj.ruleLevel != result[i-1].ruleLevel){
                            categoryTmp = categoryTmp+ "<table id='lev_"+obj.ruleLevel+"' class='type2 gray'>";
                            categoryTmp = categoryTmp+ " <caption>table</caption>";
                            categoryTmp = categoryTmp+ " <thead>";
                            categoryTmp = categoryTmp+ "     <tr id='thead_"+obj.ruleLevel+"' />";
                            categoryTmp = categoryTmp+ " </thead>";
                            categoryTmp = categoryTmp+ " <tbody>";
                            categoryTmp = categoryTmp+ "     <tr id='tbody_"+obj.ruleLevel+"' />";
                            categoryTmp = categoryTmp+ " </tbody>";
                            categoryTmp = categoryTmp+ "</table>";
                            $("#category").append(categoryTmp);
                        }
                        $("#thead_"+obj.ruleLevel).append("<th scope='col'>"+obj.ruleCategory+"</th>");
                        $("#tbody_"+obj.ruleLevel).append("<td><span>"+obj.resultValue+"</span></td>");
                    } */
                    
                    
                    console.log("valueTypeNm : "+result[0].valueTypeNm);
                    console.log("valueType : "+result[0].valueType);
                    console.log("resultValueNm : "+result[0].resultValueNm);
                     $("#searchFormRule [name=valueTypeNm]").val(result[0].valueTypeNm);
                     $("#searchFormRule [name=valueType]").val(result[0].valueType);
                     $("#searchFormRule [name=resultValueNm]").val(result[0].resultValueNm);
                }
                
            });
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
                Common.alert("<spring:message code='commission.alert.noCheckbox'/>");
                return false;
            }
            rowItem = checkedItems[0];
            str += "row : " + rowItem.rowIndex + ", id :" + rowItem.item.id + ", name : " + rowItem.item.name + "\n";
            $("#searchFormRule [name=ruleSeq]").val(rowItem.item.ruleSeq);

            Common.ajax("GET", "/commission/system/selectRuleBookMngList", $("#searchFormRule").serialize(), function(result) {
                console.log("성공.");
                console.log("data : " + result);
                $("#insertFormRule [name=orgDs]").val(result[0].orgds);
                //to-do list 1.div show(),신규인지 하위등록 인지 체크 , 조회값 셋팅
                $("#popup_wrap2").show();

                //data set
                Common.setData(result[0], $("#insertFormRule"));
                if(result[0].rulePid==null ||result[0].rulePid==""){
                    $("#insertFormRule [name=rulePid]").val("0");
                }
                
                $("#insertFormRule [name=saveType]").val("U");
                $("#printOrder").val(result[0].prtOrder);
                $("#insertFormRule [name=rulePid]").val(result[0].rulePid);
            });

        }); //editRule
        
      //rule Save
        $("#saveRule").click(function() {
            if (validationForm($("#insertFormRule"))) {
                Common.confirm("<spring:message code='sys.common.alert.save'/>",fn_saveAddRuleCall);
            }
        });
        
        //close
        $("#close02").click(function() {
            $("#insertFormRule")[0].reset();
            $("#popup_wrap2").hide();
        });
      
	});//Ready
	
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
				AUIGrid.setCellValue(myGridID, event.rowIndex, event.columnIndex + 10, data.split(",")[5]);
				AUIGrid.setCellValue(myGridID, event.rowIndex, event.columnIndex + 2, "");
				AUIGrid.setCellValue(myGridID, event.rowIndex, event.columnIndex + 3, "");
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
				if (val == null || val == "" || val == "Please select" || val == "선택하세요.") {
					Common.alert("<spring:message code='sys.common.alert.validation' arguments='ORG CD' htmlEscape='false'/>");
					return false;
				}
			}
		}
	}
	// 행 추가 이벤트 핸들러
    function auiAddRowHandler(event) {
	}
    // 행 삭제 이벤트 핸들러
    function auiRemoveRowHandler(event) {
    }

	//그리드 그룹 리스트
	function getOrgCdData(val) {
		var retStr = "";
		$.each(orgGridCdList, function(key, value) {
			var id = value.id;
			if (id == val) {
				retStr = value.orgSeq + "," + value.orgGrCd + "," + value.id + "," + value.value + "," + value.cdDs+","+value.code;
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

	// 아이템 AUIGrid 칼럼 설정
	var columnLayout = [ {
		dataField : "orgSeq",
		headerText : "ORG SEQ",
		visible : false
	}, {
		dataField : "orgGrCd",
		headerText : "ORG GR CD",
		visible : false
	}, {
		dataField : "itemSeq",
		headerText : "ITEM SEQ",
		visible : false
	}, {
		dataField : "orgCd",
		headerText : "ORG CD",
		width : 100,
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
		dataField : "orgds",
		headerText : "ORG NAME",
		width : 120,
		style : "my-column",
		editable : false
	}, {
		dataField : "itemCd",
		headerText : "ITEM CODE",
		width : 100,
		editRenderer : {
			type : "ComboBoxRenderer",
			showEditorBtnOver : true, // 마우스 오버 시 에디터버턴 보이기
			listFunction : function(rowIndex, columnIndex, item, dataField) {
				$("#ItemOrgCd").val(item.code);
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
		style : "my-column"
		//width : 617
	}, {
		dataField : "editBtn",
		headerText : "Management<br>RULE",
		styleFunction : cellStyleFunction,
		renderer : {
			type : "ButtonRenderer",
			labelText : "EDIT",
			onclick : function(rowIndex, columnIndex, value, item) {
				$("#popup_wrap").show();
                //console.log("itemCd : " + AUIGrid.getCellValue(myGridID, rowIndex, 5));
                //console.log("itemSeq : " + AUIGrid.getCellValue(myGridID, rowIndex, 0));
                //console.log("orgSeq : " + AUIGrid.getCellValue(myGridID, rowIndex, 2));
                $("#searchFormRule [name=itemCd]").val(AUIGrid.getCellValue(myGridID, rowIndex, 5));
                $("#searchFormRule [name=itemSeq]").val(AUIGrid.getCellValue(myGridID, rowIndex, 2));
                $("#searchFormRule [name=orgSeq]").val(AUIGrid.getCellValue(myGridID, rowIndex, 0));
                $("#searchFormRule [name=orgNm]").val(AUIGrid.getCellValue(myGridID, rowIndex, 4));
                $("#searchFormRule [name=itemNm]").val(AUIGrid.getCellValue(myGridID, rowIndex, 6));

                //mygridid2 option
                var options = {
                    // 체크박스 표시 설정
                    showRowCheckColumn : true,
                    showRowAllCheckBox : false,
                    // 체크박스 대신 라디오버튼 출력함
                    //rowCheckToRadio : true,
                    selectionMode : "singleRow",
                    displayTreeOpen : false,
                    // 일반 데이터를 트리로 표현할지 여부(treeIdField, treeIdRefField 설정 필수)
                    rowIdField : "ruleSeq",
                    flat2tree : true,
                      // 트리의 고유 필드명
                    treeIdField : "ruleSeq",
                     // 계층 구조에서 내 부모 행의 treeIdField 참고 필드명
                     treeIdRefField : "rulePid",
                     height : 334,
                     editable : false
                };
                if(!myGridID2){
                    myGridID2= GridCommon.createAUIGrid("grid_wrap2", columnLayout2, "ruleSeq", options);
                }
                // 체크박스 클릭 이벤트 바인딩
                AUIGrid.bind(myGridID2, "rowCheckClick", function(event) {
	                if(event.checked == true){
	                	AUIGrid.setCheckedRowsByValue(myGridID2, "ruleSeq", AUIGrid.getCellValue(myGridID2 , event.rowIndex, 3));
	                }else{
	                	AUIGrid.setAllCheckedRows(myGridID2, false);
	                }
                });
                $("#searchFormRule [name=useYnCombo]").val("Y").attr("selected", "selected");
                $("#searchRule").trigger("click");
			}
		},
        width : 150
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
        width : 150
	}, {
		dataField : "orgNm",
		headerText : "ORG Name",
		visible : false,
	}, {
		dataField : "itemNm",
		headerText : "Item Name",
		visible : false,
	}, {
	    dataField : "code",
	    headerText : "code",
	    visible : false,
	  } ];

	/**********************
	 rule AUIGrid 칼럼 설정
	**********************/
	var columnLayout2 = [   {
	    dataField : "orgds",
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
		style : "my-column"
	}, {
		dataField : "ruleOpt1",
		headerText : "Range Start Value",
		width : 100
	}, {
		dataField : "ruleOpt2",
		headerText : "Range End Value",
		width : 100
	}, {
		dataField : "valueType",
		headerText : "Range Value Type",
		width : 100
	}, {
		dataField : "resultValue",
		headerText : "Conditional Value",
		width : 100
	}, {
		dataField : "resultValueNm",
		headerText : "Condition Value Type",
		width : 100
	}, {
		dataField : "startDt",
		headerText : "Start Month/Year",
		width : 100
	}, {
		dataField : "endDt",
		headerText : "End Month/Year",
		width : 100
	}, {
		dataField : "useYn",
		headerText : "USE(Y/N)",
		width : 100
	}, {
	    dataField : "rulePid",
	    headerText : "Rule Parent ID",
	    visible : false
	  }  ];
	
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
	
    //In grid orgCdList 
    function fn_getOrgCodeListAjax(callBack) {
        Common.ajaxSync("GET", "/commission/system/selectOrgCdList", $("#searchForm").serialize(), function(result) {
            orgGridCdList = new Array();
            for (var i = 0; i < result.length; i++) {
                var list = new Object();
                list.id = result[i].orgCd;
                list.value = result[i].orgNm;
                list.cdDs = result[i].cdds;
                list.orgSeq = result[i].orgSeq;
                list.orgGrCd = result[i].orgGrCd;
                list.code = result[i].code;
                orgGridCdList.push(list);
            }
            if (callBack) {
                //   callBack(orgList);
            }
        });
    }

    //Make useYn ComboList
    function getUseYnComboList() {
        var list = [ "Y", "N" ];
        return list;
    }
    
    //addcolum button hidden
    function cellStyleFunction(rowIndex, columnIndex, value, headerText, item, dataField){
        if(item.endDt == "" || item.endDt==null){
            return "edit-column";
        }
        return "";
    }
    
    function fn_saveGridCall(){
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
            Common.alert("Fail : " + jqXHR.responseJSON.message);
            fn_getSampleListAjax();
        });
    }

	 /*  validation */
	function validation() {
		var result = true;
		var addList = AUIGrid.getAddedRowItems(myGridID);
		var udtList = AUIGrid.getEditedRowItems(myGridID);
		if (addList.length == 0 && udtList.length == 0) {
			Common.alert("<spring:message code='sys.common.alert.noChange'/>");
			return false;
		}

		for (var i = 0; i < addList.length; i++) {
			var orgSeq = addList[i].orgSeq;
			var orgGrCd = addList[i].orgGrCd;
			var orgCd = addList[i].orgCd;
			var itemCd = addList[i].itemCd;
			var useYn = addList[i].useYn;
			var typeCd = addList[i].typeCd;
			if (orgCd == "" || orgCd == "Please select" || orgCd == "선택하세요." ) {
				result = false;
				Common.alert("<spring:message code='sys.common.alert.validation' arguments='ORG CD' htmlEscape='false'/>");
				break;
			} else if (itemCd == "" || itemCd == "Please select" || itemCd == "선택하세요." ) {
				result = false;
				Common.alert("<spring:message code='sys.common.alert.validation' arguments='ITEM CD' htmlEscape='false'/>");
				break;
			} else if (useYn == "") {
				result = false;
				Common.alert("<spring:message code='sys.common.alert.validation' arguments='USER YN' htmlEscape='false'/>");
				break;
			} else if (typeCd == "") {
				result = false;
				Common.alert("<spring:message code='sys.common.alert.validation' arguments='TYPE CD' htmlEscape='false'/>");
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
			if (orgCd == "" || orgCd == "Please select" || orgCd == "선택하세요." ) {
                result = false;
                Common.alert("<spring:message code='sys.common.alert.validation' arguments='ORG CD' htmlEscape='false'/>");
                break;
            } else if (itemCd == "" || itemCd == "Please select" || itemCd == "선택하세요." ) {
                result = false;
                Common.alert("<spring:message code='sys.common.alert.validation' arguments='ITEM CD' htmlEscape='false'/>");
                break;
            } else if (useYn == "") {
                result = false;
                Common.alert("<spring:message code='sys.common.alert.validation' arguments='USER YN' htmlEscape='false'/>");
                break;
            } else if (typeCd == "") {
                result = false;
                Common.alert("<spring:message code='sys.common.alert.validation' arguments='TYPE CD' htmlEscape='false'/>");
                break;
            }
		}
		return result;
	}

    // Rule Book Mgmt grid 체크된 아이템 얻기
    function getCheckedRowItems() {
        var checkedItems = AUIGrid.getCheckedRowItems(myGridID2);
        var str = "";
        var rowItem;
        var len = checkedItems.length;

        if (len <= 0) {
            Common.alert("<spring:message code='commission.alert.noCheckbox'/>");
            return;
        }

        for (var i = 0; i < len; i++) {
            rowItem = checkedItems[i];
            str += "row : " + rowItem.rowIndex + ", id :" + rowItem.item.id + ", name : " + rowItem.item.name + "\n";
        }
        //alert(str);
    }
    
    // Rule Book Mgmt pop Save
     function fn_saveAddRuleCall(){
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
             Common.alert("Fail : " + jqXHR.responseJSON.message);
             fn_getSampleListAjax();
         });
     }
	 
	 /*  Rule Book Mgmt pop validation */
    function validationForm($form) {
        var retVal= true;
        var $input = $($form).find("input:text,select,radio,textarea");
        $.each($input, function(index, elem) {
            var name = $(this).attr("name");
            var id=$(this).attr("id");
            var val = $(this).val();
            
            if (val == null || val == "") {
                if ($(this).attr("placeholder")) {
                    name = $(this).attr("placeholder");
                }
                Common.alert("<spring:message code='sys.common.alert.validation' arguments='"+name+"' htmlEscape='false'/>");
                //Common.alert(name + ":EMPTY DATA");
                $(this).focus();
                retVal=false;
                return false;
            }
            
            if(name == "ruleOpt1" || name == "ruleOpt2" || name == "resultValue" ||name=="printOrder"){
                $(this).val($(this).val().replace(/[^-\.0-9]/g,'')  ); 
                
                 if ($(this).attr("placeholder")) {
                     name = $(this).attr("placeholder");
                 }
                 
                 if ($(this).val() == null || $(this).val() == "") {
                     Common.alert("<spring:message code='sys.common.alert.validationNumber'/>");
                     $(this).focus();
                     retVal=false;
                     return false;
                 }else{
                     if (val.split(".").length-1 >= 2) {
                         $("#"+id).val("");
                         Common.alert("<spring:message code='sys.common.alert.validationNumber'/>");
                         $(this).focus();
                         retVal=false;
                         return false;
                     }else if(val.indexOf(".")>=0){
	                     if((val.length-1)-val.indexOf(".") > 6){
	                         $("#"+id).val("");
	                         Common.alert("<spring:message code='sys.common.alert.validationNumber'/>");
	                         $(this).focus();
	                         retVal=false;
	                         return false;
	                     }
                     }
                 }
            }
            
        });
        return retVal;
    }
	 
	 function floatCh(obj){
	     $(obj).change(function(){
	         $(this).val($(this).val().replace(/[^-\.0-9]/g,'')  );  //소수점입력가능
	    }); 
	  }
	  function numberCh(obj){
	     $(obj).change(function(){
	        $(this).val($(this).val().replace(/[^0-9]/g,"")); //정수만
	    }); 
	  }
</script>


<section id="content">
	<!-- content start -->
	<ul class="path">
		<li><img src="${pageContext.request.contextPath}/resources/images/common/path_home.gif" alt="Home" /></li>
		<li>Commission</li>
		<li>Management</li>
	</ul>

	<aside class="title_line">
		<!-- title_line start -->
		<p class="fav">
			<a href="#" class="click_add_on">My menu</a>
		</p>
		<h2>Commission Group Rule Book Mgmt</h2>

		<ul class="right_btns">
			<li><p class="btn_gray">			
					<a href="#"  id="search" ><span class="search"></span><spring:message code='sys.btn.search'/></a>
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
					<a href="#" id="addRow"><span class="search"></span><spring:message code='sys.btn.add'/></a>
				</p></li>
			<li><p class="btn_grid">
                    <a href="#" id="save"><spring:message code='sys.btn.save'/></a>
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

<!-- ================ Search rule book Start ================ -->
<div id="popup_wrap" class="popup_wrap size_big"  style="display:none;"><!-- popup_wrap start -->

<header class="pop_header"><!-- pop_header start -->
<h1>Commission Rule Book Item Mgmt</h1>
<ul class="right_opt">
  <li><p class="btn_blue2"><a href="#" id="close01"><spring:message code='sys.btn.close'/></a></p></li>
</ul>
</header><!-- pop_header end -->

<section class="pop_body"  style="max-height:50%;"><!-- pop_body start -->
<form id="searchFormRule" action="" method="post">
<input type="hidden" name="itemCd" id="itemCd"/>
<input type="hidden" name="itemSeq" id="itemSeq"/>
<input type="hidden" name="orgSeq" id="orgSeq"/>
<input type="hidden" name="ruleSeq" id="ruleSeq"/>

<ul class="right_btns">
  <li><p class="btn_blue"><a href="#" id="searchRule"><span class="search"></span><spring:message code='sys.btn.search'/></a></p></li>
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
  <select name="useYnCombo" style="width: 100px;">
    <option value=""></option>
    <option value="Y">Y</option>
    <option value="N">N</option>
  </select>
  <label><input type="radio" name="use_yn" checked/><span>Actual</span></label>
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
  <th scope="row">ORG Name</th>
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
  <input type="text" title="" class="readonly w100p"  id="valueTypeNm" name="valueTypeNm" readonly="readonly" />
  </td>
</tr>
<tr>
  <th scope="row">Range value type</th>
  <td>
  <input type="text" title="" class="readonly w100p" id="valueType" name="valueType" readonly="readonly"/>
  </td>
</tr>
<tr>
  <th scope="row">Conditional Result Value Name</th>
  <td>
  <input type="text" title="" class="readonly w100p"  id="resultValueNm" name="resultValueNm" readonly="readonly"/>
  </td>
</tr>
</tbody>
</table><!-- table end -->

<ul class="right_btns">
  <li><p class="btn_grid"><a href="#" id="addRule"><spring:message code='sys.btn.add'/></a></p></li>
  <li><p class="btn_grid"><a href="#" id="editRule"><spring:message code='sys.btn.update'/></a></p></li>
  <!-- <li><p class="btn_grid"><a href="#">저장</a></p></li> -->
</ul>

<article class="grid_wrap2"><!-- grid_wrap start -->
  <!-- grid_wrap start -->
      <div id="grid_wrap2" style="width: 100%; height: 334px; margin: 0 auto;"></div>
</article><!-- grid_wrap end -->

</section><!-- search_result end -->
</form>
</section><!-- pop_body end -->

</div><!-- popup_wrap end -->
<!-- ================ Search rule book End ================ -->


<!-- ================ Insert rule book Start ================ -->
<div id="popup_wrap2" style="display:none;" class="popup_wrap"><!-- popup_wrap start -->

<header class="pop_header"><!-- pop_header start -->
<h1>Commission Rule Book Mgmt</h1>
<ul class="right_opt">
  <li><p class="btn_blue2"><a href="#" id="close02"><spring:message code='sys.btn.close'/></a></p></li>
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
  <th scope="row">Rule Category<span class="must">*</span></th>
  <td colspan="3"><input type="text" title="" placeholder="Rule Category" class="w100p" id="ruleCategory" name="ruleCategory"   maxlength="50"/></td>
</tr>
<tr>
  <th scope="row">Range Start Value<span class="must">*</span></th>
  <td><input type="text" title="" placeholder="Range Start Value" class="w100p" id="ruleOpt1" name="ruleOpt1"  onchange="floatCh(this);"  value="" maxlength="10"/></td>
  <th scope="row">Range End Value<span class="must">*</span></th>
  <td><input type="text" title="" placeholder="Range End Value" class="w100p" id="ruleOpt2" name="ruleOpt2"  onchange="floatCh(this);" value="" maxlength="10"/></td>
</tr>
<tr>
  <th scope="row">Range Value Type<span class="must">*</span></th>
  <td><input type="text" title="" placeholder="Range Value Type" class="w100p" id="valueType" name="valueType"  maxlength="50"/></td>
  <th scope="row">Range Value Type Name<span class="must">*</span></th>
  <td><input type="text" title="" placeholder="Range Value Type Name" class="w100p" id="valueTypeNm" name="valueTypeNm" maxlength="200" /></td>
</tr>
<tr>
  <th scope="row">Result Value<span class="must">*</span></th>
  <td><input type="text" title="" placeholder="Result Value" class="w100p" id="resultValue" name="resultValue"  value="" onchange="floatCh(this);" maxlength="10"/></td>
  <th scope="row">Result Value  Name<span class="must">*</span></th>
  <td><input type="text" title="" placeholder="Result Vallue  Name" class="w100p" id="resultValueNm" name="resultValueNm"  maxlength="200"/></td>
</tr>
<tr>
  <th scope="row">Print Order<span class="must">*</span></th>
  <td><input type="text" title="" placeholder="Print Order" class="w100p" id="printOrder" name="printOrder"  onchange="numberCh(this);" maxlength="2"/></td>
  
  <td colspan="2"></td>
</tr>
<tr>
  <th scope="row">Description</th>
  <td colspan="3">
    <textarea cols="40" rows="5"  id="ruleDesc" name="ruleDesc" placeholder="Rule Description" maxlength="1000"></textarea>
  </td>
</tr>
</tbody>
</table><!-- table end -->

<ul class="right_btns">
  <li><p class="btn_grid"><a href="#" id="saveRule"><spring:message code='sys.btn.save'/></a></p></li>
</ul>
</form>
</section><!-- pop_body end -->

</div><!-- popup_wrap end -->
<!-- ================ Insert rule book End ================ -->


</body>
</html>



