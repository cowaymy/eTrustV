<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>

<style type="text/css">
.my-column-left {
        text-align: left;
    }

#textAreaWrap {
    font-size: 12px;
    position: absolute;
    height: 100px;
    min-width: 100px;
    background: #fff;
    border: 1px solid #555;
    display: none;
    padding: 4px;
    text-align: right;
    z-index: 9999;
}

#textAreaWrap textarea {
    font-size: 12px;
}

.editor_btn {
        background: #ccc;
        border: 1px solid #555;
        cursor: pointer;
        margin: 2px;
        padding: 2px;
    }

.my-rec-style {
    color:#008000;
}

.my-notRec-style {
    color:#8B8000;
}

.my-advPay-style {
    color:#FF0000;
}

.my-notElig-style {
    color:#000000;
}
</style>

<script type="text/javaScript" language="javascript">

	var prdCtrlGridId;
	var chsCtrlGridId;
	var scoreRangeGridId;
	var unitEntitleGridId;
    var prodEntitleGridId;
    var keyValueList = [];
    var keyValueList2 = [];
    var keyValueList3 = [];
    var keyValueList4 = [];
    var keyValueList5 = [{code:"EXISTING", codeName:"Existing"}, {code:"NEW", codeName:"New"}];;
    var keyValueList6 = [{code:"GREEN", codeName:"GREEN"}, {code:"YELLOW", codeName:"YELLOW"}];;

	var prdCtrlGridOptions = {
		editable : true,
		groupingFields : [ "stkCtgry" ],
		displayTreeOpen : true,
		enableCellMerge : true,
		cellMergeRowSpan : false,
		showBranchOnGrouping : false,
		headerHeight : 60,
	};

	var chsCtrlGridOptions = {
		editable : true,
		wordWrap : true,
		usePaging : true,
		rowHeight : '10%',
		headerHeight : 50,
	};

// 	var scoreRangeGridOptions = {
// 			groupingFields : [ "towerType" ],
// 			displayTreeOpen : true,
// 	        enableCellMerge : true,
// 	        showBranchOnGrouping : false,
// 	        editable : true,
// 	};

	var scoreRangeHAHCGridOptions = {
			editable : false,
	        wordWrap : true,
	        usePaging : false,
	        headerHeight : 50,
	        noDataMessage : "No record found."
	};

	var scoreRangeHistGridOptions = {
			editable : false,
	        wordWrap : true,
	        headerHeight : 50,
	        showRowNumColumn : false,
	        noDataMessage : "No record found.",
	};

	var unitEntitleGridOptions = {
			editable : true,
	        wordWrap : true,
	        usePaging : true,
	        rowHeight : '10%',
	        headerHeight : 40,
	        showStateColumn : true,
	        softRemoveRowMode : false,
	};

	var prodEntitleGridOptions = {
			editable : true,
            wordWrap : true,
            usePaging : true,
            rowHeight : '10%',
            headerHeight : 40,
            showStateColumn : true,
            softRemoveRowMode : false,
	};

	var checkBoxOptions = {
		type : "CheckBoxEditRenderer",
		checkValue : 1,
		unCheckValue : 0,
		editable : true,
	};

	var gridDetailDataLength=0;

	$(document).ready(function() {
	    ccpFeedbackCode();
		chgTab();
		fn_commCodeSearch();
	});

	$(function(){
		$("#btnScoreRangeHA_Edit, #btnScoreRangeHC_Edit").click(function(){
            fn_editScoreRange();
       });

	   $("#btnUnitEntitle_Add").click(function(){
			AUIGrid.addRow(unitEntitleGridId, {}, "first");
		});

	});

	function setPrdCtrlColumnLayout() {
		return [
				{
					dataField : "stkCtgry",
					headerText : "<spring:message code='sal.text.productCategory'/>",
					width : '15%'
				},
				{
					dataField : "stkId",
					visible : false
				},
				{
					dataField : "stkDesc",
					headerText : "<spring:message code='sal.text.productName'/>",
					width : '20%'
				},

				{
					headerText : "NEW CUSTOMER",
					children : [ {
						dataField : "highScore",
						headerText : "HIGH<br/>SCORE<br/><input type='checkbox' id='highScoreCb' style='width:15px;height:15px;''>",
						width : '9%',
						renderer : checkBoxOptions,
					}, {
						dataField : "lowScore",
						headerText : "LOW<br/>SCORE<br/><input type='checkbox' id='lowScoreCb' style='width:15px;height:15px;''>",
						width : '9%',
						renderer : checkBoxOptions
					}, {
						dataField : "noScoreNoccris",
						headerText : "NO SCORE<br/>NO CCRIS<br/><input type='checkbox' id='noScoreNoCcrisCb' style='width:15px;height:15px;''>",
						width : '9%',
						renderer : checkBoxOptions
					}, {
						dataField : "noScoreInsuffCcris",
						headerText : "NO SCORE<br/>INSUFF. CCRIS<br/><input type='checkbox' id='noScoreInsuffCcrisCb' style='width:15px;height:15px;''>",
						width : '9%',
						renderer : checkBoxOptions
					}, ],
				},
				{
					headerText : "EXISTING CUSTOMER",
					children : [ {
						dataField : "chsGreen",
						headerText : "CHS GREEN<br/><input type='checkbox' id='chsGreenCb' style='width:15px;height:15px;''>",
						width : '9%',
						renderer : checkBoxOptions
					}, {
						dataField : "chsYellow",
						headerText : "CHS YELLOW<br/><input type='checkbox' id='chsYellowCb' style='width:15px;height:15px;''>",
						width : '9%',
						renderer : checkBoxOptions
					}, ],
				},
				{
                    dataField : "funcYn",
                    headerText : "TICK ALL/<br/>UNTICK ALL<br/><input type='checkbox' id='funcYnCb' style='width:15px;height:15px;''>",
                    renderer : {
                        type : "CheckBoxEditRenderer",
                        checkValue : 1,
                        unCheckValue : 0,
                        editable : true,
                         checkableFunction : function(rowIndex, columnIndex, value, isChecked, item, dataField) {

                            let checkedValue = !isChecked ? 1 : 0;

                            let checkItem = new Object();
                        	checkItem['highScore'] = checkedValue;
                            checkItem['lowScore'] = checkedValue;
                            checkItem['noScoreNoccris'] = checkedValue;
                            checkItem['noScoreInsuffCcris'] = checkedValue;
                            checkItem['chsGreen'] = checkedValue;
                            checkItem['chsYellow'] = checkedValue;

                            AUIGrid.updateRow(prdCtrlGridId, checkItem, rowIndex);

                            return true;
                        }
                    }
                }
				];
	}

	function setChsColumnLayout() {
        return [
                {
                    dataField : "remarkId",
                    visible : false
                },
                {
                    dataField : "chsRsn",
                    style : "my-column-left",
                    headerText : "<spring:message code='sal.text.reason'/>",
                    width : '10%'
                },
                {
                    dataField : "isAuto",
                    headerText : "Auto Score<br/><input type='checkbox' id='isAutoCb' style='width:15px;height:15px;''>",
                    width : '7%',
                    renderer : checkBoxOptions
                },
                {
                    dataField : "ccpRem",
                    headerText : "<spring:message code='sal.title.text.ccpRem'/>",
                    width : '60%',
                    style : "my-column-left",
                    renderer : {
                        type : "TemplateRenderer",
                    },
                    labelFunction : function (rowIndex, columnIndex, value, headerText, item ) { // HTML 템플릿 작성
                        let v = value.replace(/\n/g, '<br/>');
                        return v;
                    },
                    editRenderer: {
                        type: "InputEditRenderer",
                        showEditorBtnOver: true
                    },
                },
                {
                	dataField : "ccpResnId",
                	headerText : "<spring:message code='sal.title.text.ccpFeedbackCode' />",
                	width : '17%',
                	style : "my-column-left",
                	editable : true,
                	labelFunction : function( rowIndex, columnIndex, value, headerText, item) {
                		   let retStr = "";
                		   let selectedValue = value;
                		   $.each(keyValueList, function(index, value) {
                			   if(selectedValue == value.codeId){
                				   retStr = value.codeName;
                				   }
                			   });
                		   return retStr == "" ? value : retStr;
                    },
                	editRenderer : {
                	    type       : "DropDownListRenderer",
                        list       : keyValueList,
                        keyField   : "codeId",
                        valueField : "codeName"
                    }
                },
                {
                    dataField : "isHold",
                    headerText : "On Hold<br/><input type='checkbox' id='isHoldCb' style='width:15px;height:15px;''>",
                    width : '7%',
                    renderer : checkBoxOptions
                },

              ];
    }

	function setScoreRangeColumnLayout() {
        return [
                {
                    dataField : "scoreRangeId",
                    visible : false
                },
                {
                    dataField : "towerType",
                    headerText : " ",
                    width : '20%'
                },
                {
                    dataField : "scoreRangeType",
                    headerText : "Score Range Type",
                    width : '40%',
                    editable : false
                },
                {
                    dataField : "startScore",
                    headerText : "Start Score",
                    width : '20%',
                },
                {
                    dataField : "endScore",
                    headerText : "End Score",
                    width : '20%',
                },

                ];
    }

	function setScoreRangeHAHCColumnLayout() {
        return [
                {
                    dataField : "scoreRangeId",
                    visible : false,
                    editable : false
                },
                {
                    dataField : "scoreProv",
                    headerText : "Score Provider",
                    editable : false,
                    editable : false
                },
                {
                    dataField : "scoreGrp",
                    headerText : "Score Group",
                    editable : false
                },
                {
                    dataField : "homeCat",
                    headerText : "Home Category",
                    visible: false,
                    editable : false
                },
                {
                    dataField : "homeCatCode",
                    headerText : "Home Category Code",
                    visible: false,
                    editable : false
                },
                {
                    dataField : "startScore",
                    headerText : "Start Score",
                    editable : false
                },
                {
                    dataField : "endScore",
                    headerText : "End Score",
                    editable : false
                },
                {
                    dataField : "startDt",
                    headerText : "Start Date",
                    editable : false
                },
                {
                    dataField : "endDt",
                    headerText : "End Date",
                    editable : false
                }

        ];
    }

	function setScoreRangeHistColumnLayout() {
        return [
                {
                    dataField : "scoreRangeId",
                    visible : false,
                    editable : false
                },
                {
                    dataField : "scoreProv",
                    headerText : "Score Provider",
                    editable : false,
                    width : '10%',
                },
                {
                    dataField : "scoreGrp",
                    headerText : "Score Group",
                    width : '15%',
                    editable : false
                },
                {
                    dataField : "reason",
                    headerText : "Reason",
                    width : '30%',
                },
                {
                    dataField : "startDt",
                    headerText : "Start Date",
                },
                {
                    dataField : "endDt",
                    headerText : "End Date",
                },
                {
                    dataField : "homeCat",
                    headerText : "Home Category",
                    width : '15%',
                },
                {
                    dataField : "updDt",
                    headerText : "Update by_At",
                    width : '50%',
                    labelFunction: function( rowIndex, columnIndex, value, headerText, item){
                         return item.updDt + ' ( '+ item.updBy +' )';
                    }
                }
        ];
    }

	function setUnitEntitleColumnLayout() {
        return [
                {
                    dataField : "unitEntitleId",
                    headerText : "Unit Entitle Id",
                    visible: false
                },
                {
                    dataField : "custType",
                    headerText : "Customer Type",
                    width : '15%',
                    labelFunction : function(  rowIndex, columnIndex, value, headerText, item ) {
                        var retStr = value;
                        for(var i=0,len=keyValueList5.length; i<len; i++) {
                                if(keyValueList5[i]["code"] == value) {
                                retStr = keyValueList5[i]["codeName"];
                                break;
                            }
                        }
                        return retStr;
                    },
                    editRenderer : {
                        type : "DropDownListRenderer",
                        showEditorBtnOver : true, // 마우스 오버 시 에디터버턴 보이기
                        list : keyValueList5, //key-value Object 로 구성된 리스트
                        keyField : "code", // key 에 해당되는 필드명
                        valueField : "codeName" // value 에 해당되는 필드명
                    }
                },
                {
                    dataField : "scoreGrp",
                    headerText : "Score Group",
                    width : '15%',
                    labelFunction : function(  rowIndex, columnIndex, value, headerText, item ) {
                        var retStr = value;
                        for(var i=0,len=keyValueList2.length; i<len; i++) {
                                if(keyValueList2[i]["code"] == value) {
                                retStr = keyValueList2[i]["codeName"];
                                break;
                            }
                        }
                        return retStr;
                    },
                    editRenderer : {
                        type : "DropDownListRenderer",
                        showEditorBtnOver : true, // 마우스 오버 시 에디터버턴 보이기
                        list : keyValueList2, //key-value Object 로 구성된 리스트
                        keyField : "code", // key 에 해당되는 필드명
                        valueField : "codeName" // value 에 해당되는 필드명
                    }
                },
                {
                    dataField : "chsStus",
                    headerText : "CHS Status",
                    width : '15%',
                    labelFunction : function(  rowIndex, columnIndex, value, headerText, item ) {
                        var retStr = value;
                        for(var i=0,len=keyValueList6.length; i<len; i++) {
                                if(keyValueList6[i]["code"] == value) {
                                retStr = keyValueList6[i]["codeName"];
                                break;
                            }
                        }
                        return retStr;
                    },
                    editRenderer : {
                        type : "DropDownListRenderer",
                        showEditorBtnOver : true, // 마우스 오버 시 에디터버턴 보이기
                        list : keyValueList6, //key-value Object 로 구성된 리스트
                        keyField : "code", // key 에 해당되는 필드명
                        valueField : "codeName" // value 에 해당되는 필드명
                    }
                },
                {
                    dataField : "custCat",
                    headerText : "Customer <br>Category",
                    labelFunction : function(  rowIndex, columnIndex, value, headerText, item ) {
                        return value.toUpperCase();
                    },
                    editRenderer : {
	                    type : "InputEditRenderer",
	                    // 에디팅 유효성 검사
	                    validator : function(oldValue, newValue, item, dataField) {
	                        var isValid = true;
	                        var rtnMsg = "";
	                        var matcher = /^[_a-zA-Z]+$/;

	                        if(newValue.length > 0) {
	                            if(!matcher.test(newValue)) {
	                                isValid = false;
	                                rtnMsg = "Only alphabet is allowed.";
	                            }
	                            if(newValue.length > 1) {
	                                isValid = false;
	                                rtnMsg = "The maximum of characters is 1.";
	                            }
	                        }

	                        // 리턴값은 Object 이며 validate 의 값이 true 라면 패스, false 라면 message 를 띄움
	                        return { "validate" : isValid, "message"  : rtnMsg };
	                    }
	                }
                },
                {
                    dataField : "unitEntitle",
                    headerText : "Unit Entitlement",
                    width : '20%',
                    editRenderer : {
	                    type : "InputEditRenderer",
	                    // 에디팅 유효성 검사
	                    validator : function(oldValue, newValue, item, dataField) {
	                        var isValid = true;
	                        var rtnMsg = "";
	                        var matcher = /^[0-9]+$/;

	                        if(newValue.length > 0) {
	                            if(!matcher.test(newValue)) {
	                                isValid = false;
	                                rtnMsg = "Invalid character. Only numeric is allowed";
	                            }
	                            if(newValue > 10 || newValue < 0) {
	                                isValid = false;
	                                rtnMsg = "Only 0-10 is allowed.";
	                            }
	                        }

	                        // 리턴값은 Object 이며 validate 의 값이 true 라면 패스, false 라면 message 를 띄움
	                        return { "validate" : isValid, "message"  : rtnMsg };
	                    }
	                }
                },
                {
                    dataField : "prodEntitle",
                    headerText : "Product <br>Entitlement",
                    labelFunction : function(  rowIndex, columnIndex, value, headerText, item ) {
                        var retStr = value;
                        for(var i=0,len=keyValueList3.length; i<len; i++) {
                                if(keyValueList3[i]["code"] == value) {
                                retStr = keyValueList3[i]["codeName"];
                                break;
                            }
                        }
                        return retStr;
                    },
                    editRenderer : {
                        type : "DropDownListRenderer",
                        showEditorBtnOver : true, // 마우스 오버 시 에디터버턴 보이기
                        list : keyValueList3, //key-value Object 로 구성된 리스트
                        keyField : "code", // key 에 해당되는 필드명
                        valueField : "codeName" // value 에 해당되는 필드명
                    }
                },
                {
                    dataField : "rentFeeLimit",
                    headerText : "Rental Fee Limit <br>Per Unit",
                    labelFunction : function(  rowIndex, columnIndex, value, headerText, item ) {
                        return value.toUpperCase();
                    },
                    editRenderer : {
                        type : "InputEditRenderer",
                        // 에디팅 유효성 검사
                        validator : function(oldValue, newValue, item, dataField) {
                            var isValid = true;
                            var rtnMsg = "";
                            var matcher = /^[_a-zA-Z0-9 ]+$/;

                            if(newValue.length > 0) {
                                if(!matcher.test(newValue)) {
                                    isValid = false;
                                    rtnMsg = "Invaild character.";
                                }
                                if(newValue.length > 20) {
                                    isValid = false;
                                    rtnMsg = "The maximum of characters is 20.";
                                }
                            }

                            // 리턴값은 Object 이며 validate 의 값이 true 라면 패스, false 라면 message 를 띄움
                            return { "validate" : isValid, "message"  : rtnMsg };
                        }
                    }
                },
        ];
    }

	function setProdEntitleColumnLayout() {
        return [
        /*         {
                    dataField : "prodEntitleId",
                    headerText : "Product Entitle Id",
                    visible: false
                }, */
                {
                    dataField : "prodCatCode",
                    headerText : "Product Category",
                    width : '20%',
                    labelFunction : function(  rowIndex, columnIndex, value, headerText, item ) {
                        return item.prodCat;
                    },
                },
                {
                    dataField : "exclscore",
                    headerText : "Excellent Score",
                    width : '15%',
                    editRenderer : {
                        type : "DropDownListRenderer",
                        showEditorBtnOver : true, // 마우스 오버 시 에디터버턴 보이기
                        list : keyValueList4, //key-value Object 로 구성된 리스트
                        keyField : "code", // key 에 해당되는 필드명
                        valueField : "codeName" // value 에 해당되는 필드명
                    },
                    labelFunction : function(  rowIndex, columnIndex, value, headerText, item ) {
                        var retStr = value;
                        for(var i=0,len=keyValueList4.length; i<len; i++) {
                                if(keyValueList4[i]["code"] == value) {
                                retStr = keyValueList4[i]["codeName"];
                                break;
                            }
                        }

                        return retStr;
                    },
                    styleFunction: function(rowIndex, columnIndex, value, headerText, item, dataField) {
                           if(value == "REC"){
                               return "my-rec-style";

                           }else if (value == "NOTREC"){
                               return "my-notRec-style";

                           }else if (value == "ADVPAY"){
                               return "my-advPay-style";

                           }else if (value == "NOTELIG"){
                               return "my-notElig-style";
                           }
                    }
                },
                {
                    dataField : "goodscore",
                    headerText : "Good Score",
                    width : '15%',
                    editRenderer : {
                        type : "DropDownListRenderer",
                        showEditorBtnOver : true, // 마우스 오버 시 에디터버턴 보이기
                        list : keyValueList4, //key-value Object 로 구성된 리스트
                        keyField : "code", // key 에 해당되는 필드명
                        valueField : "codeName" // value 에 해당되는 필드명
                    },
                    labelFunction : function(  rowIndex, columnIndex, value, headerText, item ) {
                        var retStr = value;
                        for(var i=0,len=keyValueList4.length; i<len; i++) {
                                if(keyValueList4[i]["code"] == value) {
                                retStr = keyValueList4[i]["codeName"];
                                break;
                            }
                        }

                        return retStr;
                    },
                    styleFunction: function(rowIndex, columnIndex, value, headerText, item, dataField) {
                    	   if(value == "REC"){
                    		   return "my-rec-style";

                    	   }else if (value == "NOTREC"){
                    		   return "my-notRec-style";

                    	   }else if (value == "ADVPAY"){
                    		   return "my-advPay-style";

                           }else if (value == "NOTELIG"){
                        	   return "my-notElig-style";
                           }
                    }
                },
                {
                    dataField : "lowscore",
                    headerText : "Low Score",
                    width : '15%',
                    editRenderer : {
                        type : "DropDownListRenderer",
                        showEditorBtnOver : true, // 마우스 오버 시 에디터버턴 보이기
                        list : keyValueList4, //key-value Object 로 구성된 리스트
                        keyField : "code", // key 에 해당되는 필드명
                        valueField : "codeName" // value 에 해당되는 필드명
                    },
                    labelFunction : function(  rowIndex, columnIndex, value, headerText, item ) {
                        var retStr = value;
                        for(var i=0,len=keyValueList4.length; i<len; i++) {
                                if(keyValueList4[i]["code"] == value) {
                                retStr = keyValueList4[i]["codeName"];
                                break;
                            }
                        }

                        return retStr;
                    },
                    styleFunction: function(rowIndex, columnIndex, value, headerText, item, dataField) {
                           if(value == "REC"){
                               return "my-rec-style";

                           }else if (value == "NOTREC"){
                               return "my-notRec-style";

                           }else if (value == "ADVPAY"){
                               return "my-advPay-style";

                           }else if (value == "NOTELIG"){
                               return "my-notElig-style";
                           }
                    }
                },
                {
                    dataField : "insufccris",
                    headerText : "No Score Insufficient <br> CCRIS",
                    width : '15%',
                    editRenderer : {
                        type : "DropDownListRenderer",
                        showEditorBtnOver : true, // 마우스 오버 시 에디터버턴 보이기
                        list : keyValueList4, //key-value Object 로 구성된 리스트
                        keyField : "code", // key 에 해당되는 필드명
                        valueField : "codeName" // value 에 해당되는 필드명
                    },
                    labelFunction : function(  rowIndex, columnIndex, value, headerText, item ) {
                        var retStr = value;
                        for(var i=0,len=keyValueList4.length; i<len; i++) {
                                if(keyValueList4[i]["code"] == value) {
                                retStr = keyValueList4[i]["codeName"];
                                break;
                            }
                        }

                        return retStr;
                    },
                    styleFunction: function(rowIndex, columnIndex, value, headerText, item, dataField) {
                           if(value == "REC"){
                               return "my-rec-style";

                           }else if (value == "NOTREC"){
                               return "my-notRec-style";

                           }else if (value == "ADVPAY"){
                               return "my-advPay-style";

                           }else if (value == "NOTELIG"){
                               return "my-notElig-style";
                           }
                    }
                },
                {
                    dataField : "noscore",
                    headerText : "No Score",
                    width : '15%',
                    editRenderer : {
                        type : "DropDownListRenderer",
                        showEditorBtnOver : true, // 마우스 오버 시 에디터버턴 보이기
                        list : keyValueList4, //key-value Object 로 구성된 리스트
                        keyField : "code", // key 에 해당되는 필드명
                        valueField : "codeName" // value 에 해당되는 필드명
                    },
                    labelFunction : function(  rowIndex, columnIndex, value, headerText, item ) {
                        var retStr = value;
                        for(var i=0,len=keyValueList4.length; i<len; i++) {
                                if(keyValueList4[i]["code"] == value) {
                                retStr = keyValueList4[i]["codeName"];
                                break;
                            }
                        }

                        return retStr;
                    },
                    styleFunction: function(rowIndex, columnIndex, value, headerText, item, dataField) {
                           if(value == "REC"){
                               return "my-rec-style";

                           }else if (value == "NOTREC"){
                               return "my-notRec-style";

                           }else if (value == "ADVPAY"){
                               return "my-advPay-style";

                           }else if (value == "NOTELIG"){
                               return "my-notElig-style";
                           }
                    }
                },
                {
                    dataField : "excellent",
                    headerText : "Excellent",
                    width : '15%',
                    editRenderer : {
                        type : "DropDownListRenderer",
                        showEditorBtnOver : true, // 마우스 오버 시 에디터버턴 보이기
                        list : keyValueList4, //key-value Object 로 구성된 리스트
                        keyField : "code", // key 에 해당되는 필드명
                        valueField : "codeName" // value 에 해당되는 필드명
                    },
                    labelFunction : function(  rowIndex, columnIndex, value, headerText, item ) {
                        var retStr = value;
                        for(var i=0,len=keyValueList4.length; i<len; i++) {
                                if(keyValueList4[i]["code"] == value) {
                                retStr = keyValueList4[i]["codeName"];
                                break;
                            }
                        }

                        return retStr;
                    },
                    styleFunction: function(rowIndex, columnIndex, value, headerText, item, dataField) {
                           if(value == "REC"){
                               return "my-rec-style";

                           }else if (value == "NOTREC"){
                               return "my-notRec-style";

                           }else if (value == "ADVPAY"){
                               return "my-advPay-style";

                           }else if (value == "NOTELIG"){
                               return "my-notElig-style";
                           }
                    }
                },
                {
                    dataField : "good",
                    headerText : "Good",
                    width : '15%',
                    editRenderer : {
                        type : "DropDownListRenderer",
                        showEditorBtnOver : true, // 마우스 오버 시 에디터버턴 보이기
                        list : keyValueList4, //key-value Object 로 구성된 리스트
                        keyField : "code", // key 에 해당되는 필드명
                        valueField : "codeName" // value 에 해당되는 필드명
                    },
                    labelFunction : function(  rowIndex, columnIndex, value, headerText, item ) {
                        var retStr = value;
                        for(var i=0,len=keyValueList4.length; i<len; i++) {
                                if(keyValueList4[i]["code"] == value) {
                                retStr = keyValueList4[i]["codeName"];
                                break;
                            }
                        }

                        return retStr;
                    },
                    styleFunction: function(rowIndex, columnIndex, value, headerText, item, dataField) {
                           if(value == "REC"){
                               return "my-rec-style";

                           }else if (value == "NOTREC"){
                               return "my-notRec-style";

                           }else if (value == "ADVPAY"){
                               return "my-advPay-style";

                           }else if (value == "NOTELIG"){
                               return "my-notElig-style";
                           }
                    }
                },
                {
                    dataField : "moderate",
                    headerText : "Moderate",
                    width : '15%',
                    editRenderer : {
                        type : "DropDownListRenderer",
                        showEditorBtnOver : true, // 마우스 오버 시 에디터버턴 보이기
                        list : keyValueList4, //key-value Object 로 구성된 리스트
                        keyField : "code", // key 에 해당되는 필드명
                        valueField : "codeName" // value 에 해당되는 필드명
                    },
                    labelFunction : function(  rowIndex, columnIndex, value, headerText, item ) {
                        var retStr = value;
                        for(var i=0,len=keyValueList4.length; i<len; i++) {
                                if(keyValueList4[i]["code"] == value) {
                                retStr = keyValueList4[i]["codeName"];
                                break;
                            }
                        }

                        return retStr;
                    },
                    styleFunction: function(rowIndex, columnIndex, value, headerText, item, dataField) {
                           if(value == "REC"){
                               return "my-rec-style";

                           }else if (value == "NOTREC"){
                               return "my-notRec-style";

                           }else if (value == "ADVPAY"){
                               return "my-advPay-style";

                           }else if (value == "NOTELIG"){
                               return "my-notElig-style";
                           }
                    }
                },
                {
                    dataField : "poor",
                    headerText : "Poor",
                    width : '15%',
                    editRenderer : {
                        type : "DropDownListRenderer",
                        showEditorBtnOver : true, // 마우스 오버 시 에디터버턴 보이기
                        list : keyValueList4, //key-value Object 로 구성된 리스트
                        keyField : "code", // key 에 해당되는 필드명
                        valueField : "codeName" // value 에 해당되는 필드명
                    },
                    labelFunction : function(  rowIndex, columnIndex, value, headerText, item ) {
                        var retStr = value;
                        for(var i=0,len=keyValueList4.length; i<len; i++) {
                                if(keyValueList4[i]["code"] == value) {
                                retStr = keyValueList4[i]["codeName"];
                                break;
                            }
                        }

                        return retStr;
                    },
                    styleFunction: function(rowIndex, columnIndex, value, headerText, item, dataField) {
                           if(value == "REC"){
                               return "my-rec-style";

                           }else if (value == "NOTREC"){
                               return "my-notRec-style";

                           }else if (value == "ADVPAY"){
                               return "my-advPay-style";

                           }else if (value == "NOTELIG"){
                               return "my-notElig-style";
                           }
                    }
                },
                {
                    dataField : "green",
                    headerText : "Green",
                    width : '15%',
                    editRenderer : {
                        type : "DropDownListRenderer",
                        showEditorBtnOver : true, // 마우스 오버 시 에디터버턴 보이기
                        list : keyValueList4, //key-value Object 로 구성된 리스트
                        keyField : "code", // key 에 해당되는 필드명
                        valueField : "codeName" // value 에 해당되는 필드명
                    },
                    labelFunction : function(  rowIndex, columnIndex, value, headerText, item ) {
                        var retStr = value;
                        for(var i=0,len=keyValueList4.length; i<len; i++) {
                                if(keyValueList4[i]["code"] == value) {
                                retStr = keyValueList4[i]["codeName"];
                                break;
                            }
                        }

                        return retStr;
                    },
                    styleFunction: function(rowIndex, columnIndex, value, headerText, item, dataField) {
                           if(value == "REC"){
                               return "my-rec-style";

                           }else if (value == "NOTREC"){
                               return "my-notRec-style";

                           }else if (value == "ADVPAY"){
                               return "my-advPay-style";

                           }else if (value == "NOTELIG"){
                               return "my-notElig-style";
                           }
                    }
                },
                {
                    dataField : "yellow",
                    headerText : "Yellow",
                    width : '15%',
                    editRenderer : {
                        type : "DropDownListRenderer",
                        showEditorBtnOver : true, // 마우스 오버 시 에디터버턴 보이기
                        list : keyValueList4, //key-value Object 로 구성된 리스트
                        keyField : "code", // key 에 해당되는 필드명
                        valueField : "codeName" // value 에 해당되는 필드명
                    },
                    labelFunction : function(  rowIndex, columnIndex, value, headerText, item ) {
                        var retStr = value;
                        for(var i=0,len=keyValueList4.length; i<len; i++) {
                                if(keyValueList4[i]["code"] == value) {
                                retStr = keyValueList4[i]["codeName"];
                                break;
                            }
                        }

                        return retStr;
                    },
                    styleFunction: function(rowIndex, columnIndex, value, headerText, item, dataField) {
                           if(value == "REC"){
                               return "my-rec-style";

                           }else if (value == "NOTREC"){
                               return "my-notRec-style";

                           }else if (value == "ADVPAY"){
                               return "my-advPay-style";

                           }else if (value == "NOTELIG"){
                               return "my-notElig-style";
                           }
                    }
                },
        ];
    }

	function searchPrdCtrlAjax() {

		if(prdCtrlGridId != null ) AUIGrid.destroy(prdCtrlGridId);

		prdCtrlGridId = AUIGrid.create("#prdCtrl_grid",setPrdCtrlColumnLayout(), prdCtrlGridOptions);

		Common.ajax("GET", "/sales/ccp/selectProductControlList.do", "", function(data) {

			AUIGrid.bind(prdCtrlGridId, "headerClick", headerClickHandler);
			AUIGrid.setGridData(prdCtrlGridId, data);

			gridDetailDataLength = AUIGrid.getGridData(prdCtrlGridId).length;
		});
	}

	function searchChsCtrlAjax() {

		if(chsCtrlGridId != null ) AUIGrid.destroy(chsCtrlGridId);

		chsCtrlGridId = AUIGrid.create("#chsCtrl_grid",setChsColumnLayout(), chsCtrlGridOptions);

        Common.ajax("GET", "/sales/ccp/selectChsControlList.do", "", function(data) {

        	AUIGrid.bind(chsCtrlGridId, "headerClick", headerClickHandler);
            AUIGrid.setGridData(chsCtrlGridId, data);
            AUIGrid.resize(chsCtrlGridId);

            AUIGrid.bind(chsCtrlGridId, "cellEditBegin", function (event) {
            	if (event.which == "editorBtn")
            	    {createMyCustomEditRenderer(event);}
            	}
            );

            gridDetailDataLength = AUIGrid.getGridData(chsCtrlGridId).length;


            $("#confirmBtn").click(function (event) {
                let value = $("#chsCtrlTextarea").val();
                let selectedIndex = AUIGrid.getSelectedIndex(chsCtrlGridId)[0];

                AUIGrid.setCellValue(chsCtrlGridId, selectedIndex, "ccpRem", value);

                $("#textAreaWrap").hide();
            });

            $("#cancelBtn").click(function (event) {
                $("#textAreaWrap").hide();
            });
        });
    }

// 	function searchScoreRangeCtrlAjax() {
// 		if(scoreRangeGridId != null ) AUIGrid.destroy(scoreRangeGridId);

// 	    scoreRangeGridId = AUIGrid.create("#scoreRange_grid",setScoreRangeColumnLayout(), scoreRangeGridOptions);

// 		Common.ajax("GET", "/sales/ccp/selectScoreRangeControlList.do", "", function(data) {
// 			AUIGrid.setGridData(scoreRangeGridId, data);
// 		});
// 	}

	function searchScoreRangeCtrlAjax(subTab) {
		if(scoreRangeGridId != null ) AUIGrid.destroy(scoreRangeGridId);
		scoreRangeGridId = null;

		if(subTab  == "HA"){
			scoreRangeGridId = AUIGrid.create("#scoreRangeHA_grid",setScoreRangeHAHCColumnLayout(), scoreRangeHAHCGridOptions);
		}else if (subTab == "HC"){
			scoreRangeGridId = AUIGrid.create("#scoreRangeHC_grid",setScoreRangeHAHCColumnLayout(), scoreRangeHAHCGridOptions);
		}else if (subTab == "HIST"){
			scoreRangeGridId = AUIGrid.create("#scoreRangeHist_grid",setScoreRangeHistColumnLayout(), scoreRangeHistGridOptions);
		}

		Common.ajax("GET", "/sales/ccp/selectScoreRangeControlList.do", {homeCat : subTab}, function(data) {
			AUIGrid.setGridData(scoreRangeGridId, data);

			 if('${PAGE_AUTH.funcUserDefine1}'  == 'Y' &&  '${PAGE_AUTH.funcUserDefine2}' == 'Y'){
	                AUIGrid.setProp(scoreRangeGridId,"editable", true);
	            }else{
	                AUIGrid.setProp(scoreRangeGridId,"editable", false);
	            }
		});
	}

	function searchUnitEntitleAjax() {
		if(unitEntitleGridId != null ) AUIGrid.destroy(unitEntitleGridId);
		unitEntitleGridId = AUIGrid.create("#unitEntitle_grid",setUnitEntitleColumnLayout(), unitEntitleGridOptions);


		Common.ajax("GET", "/sales/ccp/selectUnitEntitleControlList.do", "", function(data) {
			AUIGrid.setGridData(unitEntitleGridId, data);

		    if('${PAGE_AUTH.funcUserDefine3}'  == 'Y' &&  '${PAGE_AUTH.funcUserDefine4}' == 'Y'){
                AUIGrid.setProp(unitEntitleGridId,"editable", true);
            }else{
                AUIGrid.setProp(unitEntitleGridId,"editable", false);
            }
		});
	}

	function searchProdEntitleAjax() {
		if(prodEntitleGridId != null ) AUIGrid.destroy(prodEntitleGridId);
		prodEntitleGridId = AUIGrid.create("#prodEntitle_grid",setProdEntitleColumnLayout(), prodEntitleGridOptions);

		Common.ajax("GET", "/sales/ccp/selectProdEntitleControlList.do", "", function(data) {
			AUIGrid.setGridData(prodEntitleGridId, data);

		    if('${PAGE_AUTH.funcUserDefine5}'  == 'Y'){
		    	AUIGrid.setProp(prodEntitleGridId,"editable", true);
		    }else{
		    	AUIGrid.setProp(prodEntitleGridId,"editable", false);
		    }

		});
	}


	function headerClickHandler(event) {
		 let headerName = event.dataField;
		 let pid = event.pid;
		 let isChecked = !document.getElementById(event.orgEvent.target.id).checked;
		 for(idx = 0 ; idx < gridDetailDataLength ; idx++){
			 updateRows(pid,isChecked,headerName,idx);
		 }
	    return false;
	};

	function updateRows(pid, isChecked,name,rowIndex){
        let checkedValue = !isChecked ? 1 : 0;
        let checkItem = new Object();
        checkItem[name] = checkedValue;

        if(pid == "#prdCtrl_grid"){
        // Apply for Product Control Setting Tick All only
            if(name == 'funcYn'){
                checkItem['highScore'] = checkedValue;
                checkItem['lowScore'] = checkedValue;
                checkItem['noScoreNoccris'] = checkedValue;
                checkItem['noScoreInsuffCcris'] = checkedValue;
                checkItem['chsGreen'] = checkedValue;
                checkItem['chsYellow'] = checkedValue;
            }

            AUIGrid.updateRow(prdCtrlGridId, checkItem, rowIndex);
        }else{
        	AUIGrid.updateRow(chsCtrlGridId, checkItem, rowIndex);
        }
    }

    function fnUpdateCtrl(gridId)
    {
    	let url = "";1

        switch(gridId){
           case  prdCtrlGridId:
              url = "/sales/ccp/saveProductControl.do";
           break;
//            case scoreRangeGridId :
//               url = "/sales/ccp/saveScoreRangeControl.do";
//            break;
           case  chsCtrlGridId:
              url = "/sales/ccp/saveChsControl.do";
           break;
           case unitEntitleGridId :
               url = "/sales/ccp/saveUnitEntitle.do";
            break;
            case  prodEntitleGridId:
               url = "/sales/ccp/saveProdEntitle.do";
            break;
        }

    	let updateList = AUIGrid.getEditedRowItems(gridId);
    	let insertNewList = AUIGrid.getAddedRowItems(gridId);
    	let data = {};
    	data.update = updateList;
    	data.add = insertNewList;
    	var editArray = [];

    	if(data.update.length < 1 && data.add.length < 1){
    		Common.alert("No Changes");
    		return;
    	}

    	if(gridId == unitEntitleGridId){
    		if(data.add.length > 0){
	    		for (var i = 0; i < data.add.length; i++){

	    		      var custType  = data.add[i].custType;
	    		      var scoreGrp  = data.add[i].scoreGrp;
	    		      var custCat  = data.add[i].custCat;
	    		      var chsStus  = data.add[i].chsStus;
	    		      var unitEntitle  = data.add[i].unitEntitle;
	    		      var prodEntitle  = data.add[i].prodEntitle;
	    		      var rentFeeLimit  = data.add[i].rentFeeLimit;

	    		      if ((custType == "" || custType == 0 || typeof(custType) == "undefined")) {
	    		          Common.alert("Customer Type is required.");
	    		          return;
	    		          break;
	    		      }

	    		      if ((scoreGrp == "" || scoreGrp == 0 || typeof(scoreGrp) == "undefined") &&
	    		    	(chsStus == "" || chsStus == 0 || typeof(chsStus) == "undefined")) {
	    		          Common.alert("Score Group or CHS Status is required.");
	    		          return;
	    		          break;
	    		      }

	    		      if (unitEntitle == "" || unitEntitle == 0 || typeof(unitEntitle) == "undefined") {
	    		          Common.alert("Unit Entitlement is required.");
	    		          return;
	    		          break;
	    		      }

	    		      if (prodEntitle == "" || prodEntitle == 0 || typeof(prodEntitle) == "undefined"){
	    		          Common.alert("Product Entitlement is required.");
	    		          return;
	    		          break;
	    		      }

	    		      if (rentFeeLimit == "" || rentFeeLimit == 0 || typeof(rentFeeLimit) == "undefined") {
	    		          Common.alert("Rent Fee Limit Per Unit is required.");
	    		          return;
	    		          break;
	    		      }

	    		      if (custCat != "" && custCat != 0 && typeof(custCat) != "undefined") {
	    		    	  data.add[i].custCat = data.add[i].custCat.toUpperCase();
	    		      }

	    		      data.add[i].rentFeeLimit = data.add[i].rentFeeLimit.toUpperCase();

	    		}
    		}

    		if(data.update.length > 0){
	    		for (var i = 0; i < data.update.length; i++){

	    			var custType  = data.update[i].custType;
	    			var scoreGrp  = data.update[i].scoreGrp;
	    			var custCat  = data.update[i].custCat;
	    			var chsStus  = data.update[i].chsStus;
                    var unitEntitle  = data.update[i].unitEntitle;
                    var prodEntitle  = data.update[i].prodEntitle;
                    var rentFeeLimit  = data.update[i].rentFeeLimit;

                    if ((custType == "" || custType == 0 || typeof(custType) == "undefined")) {
                        Common.alert("Customer Type is required.");
                        return;
                        break;
                    }

                    if ((scoreGrp == "" || scoreGrp == 0 || typeof(scoreGrp) == "undefined") &&
                      (chsStus == "" || chsStus == 0 || typeof(chsStus) == "undefined")) {
                        Common.alert("Score Group or CHS Status is required.");
                        return;
                        break;
                    }

                    if (unitEntitle == "" || unitEntitle == 0 || typeof(unitEntitle) == "undefined") {
                        Common.alert("Unit Entitlement is required.");
                        return;
                        break;
                    }

                    if (prodEntitle == "" || prodEntitle == 0 || typeof(prodEntitle) == "undefined"){
                        Common.alert("Product Entitlement is required.");
                        return;
                        break;
                    }

                    if (rentFeeLimit == "" || rentFeeLimit == 0 || typeof(rentFeeLimit) == "undefined") {
                        Common.alert("Rent Fee Limit Per Unit is required.");
                        return;
                        break;
                    }

                    if (custCat != "" && custCat != 0 && typeof(custCat) != "undefined") {
                    	data.update[i].custCat = data.update[i].custCat.toUpperCase();
                    }

                    data.update[i].rentFeeLimit = data.update[i].rentFeeLimit.toUpperCase();
	    		}
    		}
    	}else if (gridId == prodEntitleGridId){
    	    data.update = null;

    	    if(updateList.length > 0){

    	    	var rowItem, i;

    	    	for(i=0; i< updateList.length; i++){
    	    		  rowItem = updateList[i];
    	    		  var prodCatCode = null;

    	    		  for(var scoreType in rowItem){
    	    			  var scoreType2 =null ;
    	    			  var recommend = null;

    	    			    if(scoreType == "prodCatCode"){
    	    			    	prodCatCode = rowItem[scoreType];

    	    			    }else if(scoreType !== "prodCat" && scoreType !== "_$uid"
    	    			    		&& scoreType !== "seq"){

    	    			       recommend = rowItem[scoreType];
    	    			       scoreType2 = scoreType;
    	    			   }

    	    			   if(prodCatCode != null && scoreType2 != null && recommend != null){
	    	    			   editArray.push({
	    	    				   prodCatCode : prodCatCode,
	    	    				   scoreType: scoreType2.toUpperCase(),
	    	    				   recommend: recommend
	    	    			   });
    	    			   }
    	    		  }
    	    	}

    	    	 data.update = editArray;
    	    }

    	}

	   	Common.ajax("POST", url , data , function(result){
	   		Common.alert("Configuration saved", function() {
	    			switch(gridId){
	    	         case  prdCtrlGridId:
	    	      	   chgTab('prdCtrl_info');
	    	         break;
	    	//           case  scoreRangeGridId:
	       //               chgTab('scoreCtrl_info');
	         //         break;
	   	          case  chsCtrlGridId:
	  	       	   chgTab('chsCtrl_info');
	   	          break;
	   	          case  unitEntitleGridId:
	                     chgTab('unitEntitle_info');
	                 break;
	   	          case  prodEntitleGridId:
	    	       	   chgTab('prodEntitle_info');
	    	          break;
	    	      };

    		});
    	});
    }

    function createMyCustomEditRenderer(event) {

        var dataField = event.dataField;
        var $obj;
        var $textArea;

        if (dataField == "ccpRem") {
            $obj = $("#textAreaWrap").css({
                left: event.position.x,
                top: event.position.y,
                width: event.size.width - 100,
                height: 120
            }).show();
            $textArea = $("#chsCtrlTextarea").val(event.value);

            setTimeout(function () {
                $textArea.focus();
                $textArea.select();
            }, 16);
        }
    }

    function removeMyCustomEditRenderer(event) {
        $("#textAreaWrap").hide();
    }

    function chgTab(tabNm) {
    	switch(tabNm) {
        case 'prdCtrl_info' :
            searchPrdCtrlAjax();
        break;
        case 'scoreCtrl_info' :
        	searchScoreRangeCtrlAjax("HA");
        break;
    	case 'chsCtrl_info' :
    	   searchChsCtrlAjax();
    	break;
        case 'unitEntitle_info' :
        	searchUnitEntitleAjax();
        break;
    	case 'prodEntitle_info' :
    	   searchProdEntitleAjax();
    	break;
        default :
        	searchPrdCtrlAjax();
        break;
    	}
    }

    async function ccpFeedbackCode(){
        const result = await fetch("/sales/ccp/selectReasonCodeFbList");
        keyValueList = await result.json();
        /* keyValueList[0] = {codeId:0,codeName :"Choose one"}; */
        keyValueList.unshift({ codeId: 0, codeName: "Choose one" });
    };

    function chgSubTab(subTabNm){

    	switch(subTabNm) {
        case 'scoreRangeHA_info' :
        	searchScoreRangeCtrlAjax("HA");
        break;
        case 'scoreRangeHC_info' :
        	searchScoreRangeCtrlAjax("HC");
        break;
        case 'scoreRangeHist_info' :
        	searchScoreRangeCtrlAjax("HIST");
        break;
        default :
        	searchScoreRangeCtrlAjax("HA");
        break;
        }
    }

    function fn_editScoreRange(){
    	var selIdx = AUIGrid.getSelectedIndex(scoreRangeGridId)[0];

        if(selIdx > -1) {
        	var reason =  AUIGrid.getCellValue(scoreRangeGridId, selIdx, "reason");

        	if(reason == null || reason == ""){

        		var scoreRangeId = AUIGrid.getCellValue(scoreRangeGridId, selIdx, "scoreRangeId");
                var homeCatCode = AUIGrid.getCellValue(scoreRangeGridId, selIdx, "homeCatCode");
                Common.popupDiv("/sales/ccp/ccpEditScoreRangePop.do", {scoreRangeId : scoreRangeId, homeCat : homeCatCode}, null, true);

        	}else{
        		Common.alert('This edited score is not allow to edit again.');
        	}

        }
        else {
            Common.alert('Please select a Score Group to edit');
        }
    }

    function fn_commCodeSearch(){

        Common.ajax("GET", "/common/selectCodeList.do",  {groupCode : '607'}, function(result) {
            for ( var i = 0 ; i < result.length ; i++ ) {
                keyValueList2.push(result[i]);
            }
        }, null, {async : false});

        Common.ajax("GET", "/common/selectCodeList.do",  {groupCode : '605'}, function(result) {
            for ( var i = 0 ; i < result.length ; i++ ) {
                keyValueList3.push(result[i]);
            }
        }, null, {async : false});

        Common.ajax("GET", "/common/selectCodeList.do",  {groupCode : '606'}, function(result) {
            for ( var i = 0 ; i < result.length ; i++ ) {
                keyValueList4.push(result[i]);
            }
        }, null, {async : false});
    }

</script>
<section id="content">
    <ul class="path">
        <li><img
            src="${pageContext.request.contextPath}/resources/images/common/path_home.gif"
            alt="Home"
        /></li>
        <li><spring:message code='sales.path.sales' /></li>
        <li><spring:message code='sales.path.Promotion' /></li>
    </ul>
    <aside class="title_line">
        <p class="fav">
            <a href="#" class="click_add_on">My menu</a>
        </p>
        <h2>
            <spring:message code='sales.title.ccpApprovalControl' />
        </h2>
        <ul class="right_btns" style="margin-top:30px"><li/></ul>
        <section class="tap_wrap">
            <!-- tap_wrap start -->
            <ul class="tap_type1">
                <li><a id="prdCtrl_info" href="#" class="on" onClick="chgTab(this.id)">Edit Product Control Setting</a></li>
                <li><a id="scoreCtrl_info" href="#" onClick="chgTab(this.id)">Edit Score Range</a></li>
                <li><a id="chsCtrl_info" href="#" onClick="chgTab(this.id)">Edit CHS Control Setting</a></li>
                <li><a id="unitEntitle_info" href="#" onClick="chgTab(this.id)">Edit Unit Entitlement</a></li>
                <li><a id="prodEntitle_info" href="#" onClick="chgTab(this.id)">Edit Product Entitlement</a></li>
            </ul>

            <!-- PRODUCT CONTROL TAB -->
            <article class="tap_area" id="prdCtrl_info_div">
                 <ul class="right_btns" style="margin-bottom:10px">
                    <li><p class="btn_grid"><a onclick="fnUpdateCtrl(prdCtrlGridId);">SAVE</a></p></li>
                 </ul>
                 <article class="grid_wrap">
                    <div id="prdCtrl_grid" style="height:70vh"/>
                </article>
            </article>

            <!-- SCORE RANGE CONTROL TAB -->
            <article class="tap_area" id="scoreRange_info_div">
                 <div class="divine_auto">
                       <section class="tap_wrap">
			             <ul class="tap_type1">
			                <li><a id="scoreRangeHA_info" href="#" class="on" onClick="chgSubTab(this.id)">Home Appliance</a></li>
			                <li><a id="scoreRangeHC_info" href="#" onClick="chgSubTab(this.id)">Homecare</a></li>
			                <li><a id="scoreRangeHist_info" href="#" onClick="chgSubTab(this.id)">History</a></li>
			             </ul>

                         <article class="tap_area" id="scoreRangeHA_info_div">
                            <ul class="right_btns" style="margin-bottom:10px">
                                <c:if test="${PAGE_AUTH.funcUserDefine1 == 'Y'}">
			                     <li><p class="btn_grid"><a id="btnScoreRangeHA_Edit">EDIT</a></p></li>
			                    </c:if>
		                    </ul>
                            <article class="grid_wrap">
			                     <div id="scoreRangeHA_grid" style="height:70vh"/>
			                </article>
			             </article>

			             <article class="tap_area" id="scoreRangeHC_info_div">
		                     <ul class="right_btns" style="margin-bottom:10px">
                                 <c:if test="${PAGE_AUTH.funcUserDefine2 == 'Y'}">
                                    <li><p class="btn_grid"><a id="btnScoreRangeHC_Edit">EDIT</a></p></li>
                                 </c:if>
                             </ul>
			                 <article class="grid_wrap">
                                <div id="scoreRangeHC_grid" style="height:70vh"/>
                              </article>
                           </article>

                            <article class="tap_area" id="scoreRangeHist_info_div">
                                <article class="grid_wrap">
                                    <div id="scoreRangeHist_grid" style="height:70vh"/>
                                </article>
                           </article>
                       </section>
                 </div>
            </article>

            <!-- CHS CONTROL TAB -->
            <article class="tap_area" id="chs_info_div">
            <ul class="right_btns" style="margin-bottom:10px">
                    <li><p class="btn_grid"><a onclick="fnUpdateCtrl(chsCtrlGridId);">SAVE</a></p></li>
                 </ul>
                <div id="chsCtrl_grid" style="height:70vh"/>
            </article>

            <!-- UNIT ENTITLMENT TAB -->
            <article class="tap_area" id="unitEntitle_info_div">
                <ul class="right_btns" style="margin-bottom:10px">
                    <c:if test="${PAGE_AUTH.funcUserDefine3 == 'Y'}">
                        <li><p class="btn_grid"><a id="btnUnitEntitle_Add">Add</a></p></li>
                    </c:if>
                    <c:if test="${PAGE_AUTH.funcUserDefine4 == 'Y'}">
                        <li><p class="btn_grid"><a onclick="fnUpdateCtrl(unitEntitleGridId);">SAVE</a></p></li>
                    </c:if>
                 </ul>
                <article class="grid_wrap">
                    <div id="unitEntitle_grid" style="height:70vh"/>
                </article>
            </article>

             <!-- PRODUCT ENTITLEMENT TAB -->
            <article class="tap_area" id="prodEntitle_info_div">
                <ul class="right_btns" style="margin-bottom:10px">
                    <c:if test="${PAGE_AUTH.funcUserDefine5 == 'Y'}">
                        <li><p class="btn_grid"><a onclick="fnUpdateCtrl(prodEntitleGridId);">SAVE</a></p></li>
                    </c:if>
                 </ul>
                 <article class="grid_wrap">
                    <div id="prodEntitle_grid" style="height:70vh"/>
                </article>
            </article>
        </section>
        <!--  tab -->
        <!-- grid_wrap end -->

        <div id="textAreaWrap">
        <textarea id="chsCtrlTextarea" style="width:100%; height:90px;"></textarea>
            <ul class="right_btns" style="margin-top:4px;">
                <li><p class="btn_grid"><a id="confirmBtn">confirm</a></p></li>
                <li><p class="btn_grid"><a id="cancelBtn">cancel</a></p></li>
            </ul>
        </div>

</section>
</section>
</aside>
