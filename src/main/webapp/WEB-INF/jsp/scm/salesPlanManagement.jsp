<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/tiles/view/common.jsp" %>
<style type="text/css">
/* 칼럼 스타일 전체 재정의 */
.aui-grid-left-column {
  text-align:left;
}

/* 커스텀 칼럼 스타일 정의 */
.my-column {
    text-align:right;
    margin-top:-20px;
}

.my-backColumn1 {
  text-align:right;
  background:#818284;
  color:#000;
}

.my-backColumn2 {
  text-align:right;
  background:#a1a2a3;
  color:#000;
}

.my-editable {
  background:#A9BCF5;
  color:#000;
}

.Atag-Disabled {
   pointer-events: none;
   cursor: default;
}

</style>

<script type="text/javaScript">

var gSelMainRowIdx = 0;
var gSelMstRolLvl = "";
var dealerComboBoxList = new Array();
var gPlanId = "";
var gWeekThValue ="";
var gplanDtlId = "";  // seq
var gplanMasterId = "";
var insertVisibleFields = ["scmGrYear","scmGrWeek","preM3AvgOrded","preM3AvgIssu","newStockTypeId","newStockCode","m1Ord", "m2Ord"  ,"m3Ord" ,"m33" ,"m22",  "m11" ,"m0Plan"  ,"m0Ord" ] ;

var gM0	= "";	var	gM1	= "";	var gM2	= "";	var gM3	= "";
//var gAddrowCnt = 0;

$(function()
{
 //stock type
	fnSelectStockTypeComboList('15');
 // set Year
  fnSelectExcuteYear();
 // set PeriodByYear
  fnSelectPeriodReset();
 //setting scm teamCode ComboBox
	fnSetSCMTeamComboBox();
 //setting StockCategoryCode ComboBox
	fnSetStockCategoryComboBox();
 //setting StockCode ComboBox
	fnSetStockComboBox();

});

/*********************************/
 var mstColumnLayout =
    [
        {
            dataField : "codeMasterId",
            headerText : "<spring:message code='sys.generalCode.grid1.MASTER_ID' />",
            width : "8%",
        }, {
            dataField : "codeMasterName",
            headerText : "<spring:message code='sys.generalCode.grid1.MASTER_NAME' />",
            style : "aui-grid-left-column",
            width : "25%",
        }, {
            dataField : "codeDesc",
            headerText : "<spring:message code='sys.generalCode.grid1.CODE_DESCRIPTION' />",
            style : "aui-grid-left-column",
            width : "30%",
        }, {
            dataField : "createName",
            headerText : "<spring:message code='sys.generalCode.grid1.CREATOR' />",
            style : "aui-grid-left-column",
            width : "13%",
        }, {
            dataField : "crtDt",
            headerText : "<spring:message code='sys.generalCode.grid1.CREATE_DATE' />",
            dataType : "date",
            formatString : "dd-mmm-yyyy HH:MM:ss",
            width : "15%",
        }, {
            dataField : "disabled",
            headerText : "<spring:message code='sys.generalCode.grid1.DISABLED' />",
            width : "9%",
            editRenderer : {
                type : "ComboBoxRenderer",
                showEditorBtnOver : true, // 마우스 오버 시 에디터버턴 보이기
                listFunction : function(rowIndex, columnIndex, item, dataField) {
                   var list = getDisibledComboList();
                   return list;
                },
                keyField : "id"
            }
        }
    ];


/********************************/

function fnSelectPeriodReset()
{
   CommonCombo.initById("scmPeriodCbBox");  // reset...
   var periodCheckBox = document.getElementById("scmPeriodCbBox");
       periodCheckBox.options[0] = new Option("Select a YEAR","");
}

//	create
function fnCreate(obj) {
	if ( true == $(obj).parents().hasClass("btn_disabled") ) {
		return	false;
	}
	if ( $("#scmYearCbBox").val().length < 1 ) {
		Common.alert("<spring:message code='sys.msg.necessary' arguments='YEAR' htmlEscape='false'/>");
		return	false;
	}
	if ( $("#scmPeriodCbBox").val().length < 1 ) {
		Common.alert("<spring:message code='sys.msg.necessary' arguments='YEAR' htmlEscape='false'/>");
		return	false;
	}
	if ( $("#scmTeamCbBox").val().length < 1 ) {
		Common.alert("<spring:message code='sys.msg.necessary' arguments='TEAM' htmlEscape='false'/>");
		return	false;
	}
	
	Common.ajax("POST"
			, "/scm/insertSalesPlanMaster.do"
			, $("#MainForm").serializeJSON()
			, function(result) {
				if ( 99 == result.code ) {
					Common.alert("Already Created Sales Plan.");
				} else {
					Common.alert(result.data  + "<spring:message code='sys.msg.savedCnt'/>");
					fnSettiingHeader();
					console.log("성공." + JSON.stringify(result) + " /data : " + result.data);
				}
			}
			, function(jqXHR, textStatus, errorThrown) {
				try {
					console.log("Fail Status : " + jqXHR.status);
					console.log("code : "        + jqXHR.responseJSON.code);
					console.log("message : "     + jqXHR.responseJSON.message);
					console.log("detailMessage : "  + jqXHR.responseJSON.detailMessage);
				} catch ( e ) {
					console.log(e);
				}
				Common.alert("Fail : " + jqXHR.responseJSON.message);
			});
}

//	confirm
function fnConfirm(obj) {
	if ( true == $(obj).parents().hasClass("btn_disabled") ) {
		return	false;
	}
	var planId	= "";
	var scmTeamCbBox	= $("#scmTeamCbBox").val();
	
	if ( "" == scmTeamCbBox ) {
		Common.alert("Select Team");
		return	false;
	} else if ( "DST" == scmTeamCbBox ) {
		planId	= $("#planId1").val();
	} else if ( "CODY" == scmTeamCbBox ) {
		planId	= $("#planId2").val();
	} else if ( "CS" == scmTeamCbBox ) {
		planId	= $("#planId3").val();
	} else {
		Common.alert("Error");
		return	false;
	}
/*	if ( $("#scmYearCbBox").val().length < 1 ) {
		Common.alert("<spring:message code='sys.msg.necessary' arguments='YEAR' htmlEscape='false'/>");
		return	false;
	}
	if ( $("#scmPeriodCbBox").val().length < 1 ) {
		Common.alert("<spring:message code='sys.msg.necessary' arguments='WEEK_TH' htmlEscape='false'/>");
		return	false;
	}*/
	
	Common.ajax("POST"
			, "/scm/updateSalesPlanConfirm.do"
			//, $("#MainForm").serializeJSON()
			, { planId : planId }
			, function(result) {
				Common.alert(result.data  + "<spring:message code='sys.msg.savedCnt'/>");
				fnSearchBtnList();
				console.log("성공." + JSON.stringify(result) + " /data : " + result.data);
			}
			, function(jqXHR, textStatus, errorThrown) {
				try {
					console.log("Fail Status : " + jqXHR.status);
					console.log("code : "        + jqXHR.responseJSON.code);
					console.log("message : "     + jqXHR.responseJSON.message);
					console.log("detailMessage : "  + jqXHR.responseJSON.detailMessage);
				} catch ( e ) {
					console.log(e);
				}
				Common.alert("Fail : " + jqXHR.responseJSON.message);
			});
	/*	if ( $("#scmTeamCbBox").val().length > 1 ) {
		
	}
	  if ($("#scmTeamCbBox").val().length >1)
	  {
		Common.alert("Please Select Team ALL.");
	    return false;
	  }*/
}

//	unconfirm
function fnUnConfirm(obj) {
	if ( true == $(obj).parents().hasClass("btn_disabled") ) {
		return	false;
	}
	var planId	= "";
	var scmTeamCbBox	= $("#scmTeamCbBox").val();
	
	if ( "" == scmTeamCbBox ) {
		Common.alert("Select Team");
		return	false;
	} else if ( "DST" == scmTeamCbBox ) {
		planId	= $("#planId1").val();
	} else if ( "CODY" == scmTeamCbBox ) {
		planId	= $("#planId2").val();
	} else if ( "CS" == scmTeamCbBox ) {
		planId	= $("#planId3").val();
	} else {
		Common.alert("Error");
		return	false;
	}
/*	if ( $("#scmYearCbBox").val().length < 1 ) {
		Common.alert("<spring:message code='sys.msg.necessary' arguments='YEAR' htmlEscape='false'/>");
		return	false;
	}
	if ( $("#scmPeriodCbBox").val().length < 1 ) {
		Common.alert("<spring:message code='sys.msg.necessary' arguments='YEAR' htmlEscape='false'/>");
		return	false;
	}*/
	
	Common.ajax("POST"
			, "/scm/updateSalesPlanUnConfirm.do"
			//, $("#MainForm").serializeJSON()
			, { planId : planId }
			, function(result) {
				Common.alert(result.data  + "<spring:message code='sys.msg.savedCnt'/>");
				fnSearchBtnList();
				console.log("성공." + JSON.stringify(result) + " /data : " + result.data);
			}
			, function(jqXHR, textStatus, errorThrown) {
				try {
					console.log("Fail Status : " + jqXHR.status);
					console.log("code : "        + jqXHR.responseJSON.code);
					console.log("message : "     + jqXHR.responseJSON.message);
					console.log("detailMessage : "  + jqXHR.responseJSON.detailMessage);
				} catch ( e ) {
					console.log(e);
				}
				Common.alert("Fail : " + jqXHR.responseJSON.message);
			});
}

//	save
function fnSave(obj) {
	if ( true == $(obj).parents().hasClass("btn_disabled") ) {
		return	false;
	}
	if ( false == fnValidationCheck() ) {
		return	false;
	}
	
	Common.ajax("POST"
			, "/scm/saveScmSalesPlan.do"
			, GridCommon.getEditData(myGridID)
			, function(result) {
				Common.alert(result.data  + "<spring:message code='sys.msg.savedCnt'/>");
				fnSearchBtnList();
				console.log("성공." + JSON.stringify(result) + " /data : " + result.data);
			}
			, function(jqXHR, textStatus, errorThrown) {
				try {
					console.log("HeaderFail Status : " + jqXHR.status);
					console.log("code : "        + jqXHR.responseJSON.code);
					console.log("message : "     + jqXHR.responseJSON.message);
					console.log("detailMessage : "  + jqXHR.responseJSON.detailMessage);
				} catch ( e ) {
					console.log(e);
				}
				Common.alert("Fail : " + jqXHR.responseJSON.message);
			});
}

//	validation check
function fnValidationCheck() {
	var result	= true;
	var updList	= AUIGrid.getEditedRowItems(myGridID);
	
	if ( 0 == updList.length ) {
		Common.alert("No Change");
		return	false;
	}
	
	return	result;
}

//	excel
function fnExcel(obj, fileNm) {
	//	1. grid ID
	//	2. type : "xlsx", "csv", "txt", "xml", "json", "pdf", "object"
	//	3. export ExcelFileName MonthlyGridID, WeeklyGridID
	if ( true == $(obj).parents().hasClass("btn_disabled") ) {
		return	false;
	}
	GridCommon.exportTo("#dynamic_DetailGrid_wrap", "xlsx", fileNm + '_' + getTimeStamp());
}


function fnNumberCheck(inputs)
{
		if(/[^0123456789]/g.test(inputs))
		{
		  Common.alert("<spring:message code='sys.common.alert.validationNumber' />");
		  inputs = "";
		  return false;
		}
		else
			return true;
}

function getTimeStamp()
{
  function leadingZeros(n, digits) {
      var zero = '';
      n = n.toString();
      if (n.length < digits) {
          for (i = 0; i < digits - n.length; i++)
              zero += '0';
      }
      return zero + n;
  }

  var d = new Date();
  var date = leadingZeros(d.getFullYear(), 4)+ leadingZeros(d.getMonth() + 1, 2)+ leadingZeros(d.getDate(), 2);
  var time = leadingZeros(d.getHours(), 2)+leadingZeros(d.getMinutes(), 2) + leadingZeros(d.getSeconds(), 2);

  return date+"_"+time
}


function fnSelectStockTypeComboList(codeId)
{
    CommonCombo.make("scmStockType"
              , "/scm/selectComboSupplyCDC.do"
              , { codeMasterId: codeId }
              , ""
              , {
                  id  : "codeId",     // use By query's parameter values(real value)
                  name: "codeName",   // display
                  type: "M",
                  chooseMessage: "All"
                 }
              , "");
}

function fnSelectExcuteYear()
{
    // Call Back
    var fnSelectScmPeriodCallBack = function ()
        {
          $('#scmYearCbBox').on("change", function () //  When 'scmYearCbBox' Change Event Excute.
          {
            var $this = $(this);  // selected item , will use scmPeriodCbBox's input-parameter.

            //console.log("period_values: " + $this.val());

            CommonCombo.initById("scmPeriodCbBox");  // reset...

            if (FormUtil.isNotEmpty($this.val()))
            {
                CommonCombo.make("scmPeriodCbBox"
                        , "/scm/selectPeriodByYear.do"
                        , { year: $this.val() }
                        , ""
                        , {
                            id  : "weekTh",
                            name: "scmPeriod",
                            chooseMessage: "Select a WEEK"
                           }
                        , "");
            }
            else
            {
            	fnSelectPeriodReset();
            }

          });
        };

	  CommonCombo.make("scmYearCbBox"
                   , "/scm/selectExcuteYear.do" // url
                   , ""                         // input Param
                   , ""                         // selectData
                   , {
                	     id  : "year",
                       name: "year",            // option
                       chooseMessage: "Year"
                     }
                   , fnSelectScmPeriodCallBack); // callback
}

function fnSetSCMTeamComboBox()
{
    CommonCombo.make("scmTeamCbBox"
    	             , "/scm/selectScmTeamCode.do"
    	             , {codeMasterId: 337}
    	             , ""
    	             , {
							         id  : "code",
							         name: "codeName",
							         chooseMessage: "ALL"
							       }
				           , "");
}

function fnSetStockComboBox()
{
    CommonCombo.make("stockCodeCbBox"
                   , "/scm/selectStockCode.do"
                   , ""
                   , ""
                   , {
                       id  : "stkCode",
                       name: "stkDesc",
                       type: "M"
                     }
                   , "");
}

function fnSetStockCategoryComboBox()
{
	  // Call Back
    var stockCodeCallBack = function ()
        {

    	    $('#stockCategoryCbBox').on("change", function ()
          {
            var $this = $(this);

            //console.log("values: " + $this.val());

            CommonCombo.initById("stockCodeCbBox");

            if (FormUtil.isNotEmpty($this.val()))
            {
                CommonCombo.make("stockCodeCbBox"
				                        , "/scm/selectStockCode.do"
				                        , { codeIds: $this.val() + "" }  //
				                        , ""
				                        , {
				                        	  id  : "stkCode",
									                  name: "stkDesc",
									                  type: "M"
									                }
						                    , "");
            }
            else
            { // ALL
            	fnSetStockComboBox();
            }

          });
        };

    CommonCombo.make("stockCategoryCbBox"
    	             , "/scm/selectStockCategoryCode.do"
    	             , ""
    	             , ""
    	             , {
                         id  : "codeId",
                         name: "codeName",
                         type: "M"
        	           }
				           , stockCodeCallBack  // callback
				            );
}

function getDealerComboListAjax(callBack)
{
    Common.ajaxSync("GET", "/common/selectGSTExportDealerList.do"
                 , $("#MainForm").serialize()
                 , function(result)
                 {
                    for (var i = 0; i < result.length; i++)
                    {
                      var list = new Object();
                          list.id = result[i].dealerId;
                          list.value = result[i].dealerName ;

                          dealerComboBoxList.push(list);
                    }

                    //if you need callBack Function , you can use that function
                    if (callBack)
                    {
                      callBack(dealerComboBoxList);
                    }

                  });
    return dealerComboBoxList;
  }

//AUIGrid 메소드
//컬럼 선택시 상세정보 세팅.
function fnSetSelectedColumn(selGrdidID, rowIdx)
{
 $("#selAuthId").val(AUIGrid.getCellValue(selGrdidID, rowIdx, "zreExptId"));

 //console.log("selAuthId: "+ $("#selAuthId").val() + " dealerName: " + AUIGrid.getCellValue(selGrdidID, rowIdx, "dealerName") );
}

function auiCellEditingHandler(event) {
	if ( "cellEditBegin" == event.type ) {
		//console.log("에디팅 시작(cellEditBegin) : (rowIdx: " + event.rowIndex + ",columnIdx: " + event.columnIndex + " ) " + event.headerText + ", value : " + event.value);
	} else if ( "cellEditEnd" == event.type ) {
		//console.log("에디팅 종료(cellEditEnd) : ( " + event.rowIndex + ", " + event.columnIndex + " ) " + event.headerText + ", value : " + event.value );
		
		if ( false == fnNumberCheck(event.value) ) {
			console.log("숫자아님(cellEditEnd)");
			AUIGrid.setCellValue(myGridID, event.rowIndex, event.columnIndex, "");
		}
		
		//	자동계산
		//var header	= AUIGrid.getCellValue(myGridID, 0, event.columnIndex);
		/*var m0	= AUIGrid.getColumnItemByDataField(myGridID, "M+0");
		var m1	= AUIGrid.getColumnItemByDataField(myGridID, "M+1");
		var m2	= AUIGrid.getColumnItemByDataField(myGridID, "M+2");
		var m3	= AUIGrid.getColumnItemByDataField(myGridID, "M+3");
		var m4	= AUIGrid.getColumnItemByDataField(myGridID, "M+4");*/
		console.log("M0 : " + gM0 + ", M1 : " + gM1 + ", M2 : " + gM2 + ", M3 : " + gM3);
		//	수정한 셀이 M0 ~ M3 중 어디인지 체크
		if ( event.columnIndex >= 28 && event.columnIndex < parseInt(28) + parseInt(gM0) ) {
			//	M+0 합계
			
		} else if ( event.columnIndex >= parseInt(28) + parseInt(gM0) && event.columnIndex < parseInt(28) + parseInt(gM0) + parseInt(gM1) ) {
			//	M+1 합계
			console.log("from : " + parseInt(parseInt(28) + parseInt(gM0)) +" to : " + parseInt(parseInt(28) + parseInt(gM0) + parseInt(gM1)));
			var	m1Sum	= AUIGrid.getCellValue(myGridID, event.rowIndex, "M+1");
			console.log("before m1Sum : " + m1Sum);
			m1Sum	= m1Sum + event.value;
			console.log("after m1Sum : " + m1Sum);
			AUIGrid.setCellValue(myGridID, event.rowIndex, "M+1", m1Sum);
		} else if ( event.columnIndex >= parseInt(28) + parseInt(gM0) + parseInt(gM1) && event.columnIndex < parseInt(28) + parseInt(gM0) + parseInt(gM1) + parseInt(gM2) ) {
			//	M+2 합계
		} else if ( event.columnIndex >= parseInt(28) + parseInt(gM0) + parseInt(gM1) + parseInt(gM2) && event.columnIndex < parseInt(28) + parseInt(gM0) + parseInt(gM1) + parseInt(gM2) + parseInt(gM3) ) {
			//	M+3 합계
		}
	} else if ( "cellEditCancel" == event.type ) {
		//console.log("에디팅 취소(cellEditCancel) : ( " + event.rowIndex + ", " + event.columnIndex + " ) " + event.headerText + ", value : " + event.value);
	}
}

//행 추가 이벤트 핸들러
function auiAddRowHandler(event)
{
  console.log(event.type + " 이벤트\r\n" + "삽입된 행 인덱스 : " + event.rowIndex + "\r\n삽입된 행 개수 : " + event.items.length);
}


//Make Use_yn ComboList, tooltip


//행 삭제 이벤트 핸들러
function auiRemoveRowHandler(event)
{
  console.log (event.type + " 이벤트 :  " + ", 삭제된 행 개수 : " + event.items.length + ", softRemoveRowMode : " + event.softRemoveRowMode);
  gAddrowCnt = 0;
}

//행 삭제 이벤트 핸들러
function auiRemoveRowHandlerDetail(event)
{
  console.log (event.type + " 이벤트상세 :  " + ", 삭제된 행 개수 : " + event.items.length + ", softRemoveRowMode : " + event.softRemoveRowMode);
  gAddrowCnt = 0;
}

//행 삭제 메소드
function fnRemoveRow()
{
  AUIGrid.removeRow(myGridID,"selectedIndex");
}

function fnSearchRolePopUp()
{
   var popUpObj = Common.popupDiv("/authorization/searchRolePop.do"
       , $("#MainForm").serializeJSON()
       , null
       , true
       , "SearchRolePop"
       );

}

function fnSetParamAuthCd(myGridID, rowIndex)
{
  $("#zreExptId").val(AUIGrid.getCellValue(myGridID, rowIndex, "zreExptId"));
  $("#dealerName").val(AUIGrid.getCellValue(myGridID, rowIndex, "dealerName"));

  //console.log("zreExptId: "+ $("#zreExptId").val() + "dealerName: "+ $("#dealerName").val() );
}

function fnSettiingHeader()
{
	if ( $("#scmYearCbBox").val().length < 1 ) {
		Common.alert("<spring:message code='sys.msg.necessary' arguments='YEAR' htmlEscape='false'/>");
		return	false;
	}
	if ( $("#scmPeriodCbBox").val().length < 1 ) {
		Common.alert("<spring:message code='sys.msg.necessary' arguments='WEEK_TH' htmlEscape='false'/>");
		return	false;
	}
	
	var dynamicLayout	= [];
	var dynamicOption	= {};
	
	//	이전에 그리드가 생성되었다면 제거함.
	if ( AUIGrid.isCreated(myGridID) ) {
		AUIGrid.destroy(myGridID);
	}
	
	dynamicOption	= {
			usePaging : true,
			useGroupingPanel : false,
			showRowNumColumn : false,		//	순번 칼럼 숨김
			editable : true,
			showStateColumn : true,			//	행 상태 칼럼 보이기
			showEditedCellMarker : true,	//	셀 병합 실행
			enableCellMerge : true,			//	고정칼럼 카운트 지정
			fixedColumnCount : 8,
			enableRestore : true,
			softRemovePolicy : "exceptNew",	//	사용자추가한 행은 바로 삭제
			showRowCheckColumn : true,		//	체크박스 표시 설정
			independentAllCheckBox : true,	//	전체 선택 체크박스가 독립적인 역할을 할지 여부
			usePaging : false,				//	페이징처리 설정
			rowCheckableFunction : function(rowIndex, isChecked, item) {
				//	In case of "Confirm", don't user check
				if ( 4 == item.checkFlag ) {
					return	false;
				}
				return	true;
			},
			rowCheckDisabledFunction : function(rowIndex, isChecked, item) {
				if ( 4 == item.checkFlag ) {
					return	false;	//	disabled
				}
				return	true;
			}
	};
	
	Common.ajax("POST"
			, "/scm/selectCalendarHeader.do"
			, $("#MainForm").serializeJSON()
			, function(result) {
				console.log(result);
				if ( null == result.planInfo ) {
					$("#planYear1").text("");		$("#planYear2").text("");		$("#planYear3").text("");
					$("#planMonth1").text("");		$("#planMonth2").text("");		$("#planMonth3").text("");
					$("#planWeek1").text("");		$("#planWeek2").text("");		$("#planWeek3").text("");
					$("#planTeam1").text("");		$("#planTeam2").text("");		$("#planTeam3").text("");
					$("#planStatus1").text("");		$("#planStatus2").text("");		$("#planStatus3").text("");
					$("#planCreatedAt1").text("");	$("#planCreatedAt2").text("");	$("#planCreatedAt3").text("");
					$("#planId1").val("");			$("#planId2").val("");			$("#planId3").val("");
					$("#planStusId1").val("");		$("#planStusId2").val("");		$("#planStusId3").val("");
					
					Common.alert("Noo data found!!");
					fnButtonControl();
					return;
				}
				
				//	Selected Data accuracy
				if ( (result.planInfo == null || result.planInfo.length < 1)
						|| (result.seperaionInfo == null || result.seperaionInfo.length < 1)
						|| (result.getChildField == null || result.getChildField.length < 1) ) {
					//Common.alert("<spring:message code='expense.msg.NoData' />");
					Common.alert("Selected Data is empty");
					
					//	If no data, destroy grid
					if ( AUIGrid.isCreated(myGridID) ) {
						AUIGrid.destroy(myGridID);
					}
					//	If no data, setting Plan Status ""
					$("#planYear1").text("");		$("#planYear2").text("");		$("#planYear3").text("");
					$("#planMonth1").text("");		$("#planMonth2").text("");		$("#planMonth3").text("");
					$("#planWeek1").text("");		$("#planWeek2").text("");		$("#planWeek3").text("");
					$("#planTeam1").text("");		$("#planTeam2").text("");		$("#planTeam3").text("");
					$("#planStatus1").text("");		$("#planStatus2").text("");		$("#planStatus3").text("");
					$("#planCreatedAt1").text("");	$("#planCreatedAt2").text("");	$("#planCreatedAt3").text("");
					
					return	false;
				}
				
				/*
				2018.09.02 : result max count is 3
				*/
				//	Plan Status Info setting
				if ( result.planInfo != null && result.planInfo.length > 0 ) {
					for ( var i = 0 ; i < result.planInfo.length ; i++ ) {
						if ( "DST" == result.planInfo[i].team ) {
							$("#planYear1").text(result.planInfo[i].planYear);
							$("#planMonth1").text(result.planInfo[i].planMonth);
							$("#planWeek1").text(result.planInfo[i].planWeek);
							$("#planTeam1").text(result.planInfo[i].team);
							$("#planStatus1").text(result.planInfo[i].planStusNm);
							$("#planCreatedAt1").text(result.planInfo[i].crtDt);
							$("#planId1").val(result.planInfo[i].planId);
							$("#planStusId1").val(result.planInfo[i].planStusId);
							$("#created1").val(result.planInfo[i].created);
						} else if ( "CODY" == result.planInfo[i].team ) {
							$("#planYear2").text(result.planInfo[i].planYear);
							$("#planMonth2").text(result.planInfo[i].planMonth);
							$("#planWeek2").text(result.planInfo[i].planWeek);
							$("#planTeam2").text(result.planInfo[i].team);
							$("#planStatus2").text(result.planInfo[i].planStusNm);
							$("#planCreatedAt2").text(result.planInfo[i].crtDt);
							$("#planId2").val(result.planInfo[i].planId);
							$("#planStusId2").val(result.planInfo[i].planStusId);
							$("#created2").val(result.planInfo[i].created);
						} else if ( "CS" == result.planInfo[i].team ) {
							$("#planYear3").text(result.planInfo[i].planYear);
							$("#planMonth3").text(result.planInfo[i].planMonth);
							$("#planWeek3").text(result.planInfo[i].planWeek);
							$("#planTeam3").text(result.planInfo[i].team);
							$("#planStatus3").text(result.planInfo[i].planStusNm);
							$("#planCreatedAt3").text(result.planInfo[i].crtDt);
							$("#planId3").val(result.planInfo[i].planId);
							$("#planStusId3").val(result.planInfo[i].planStusId);
							$("#created3").val(result.planInfo[i].created);
						}
					}
				}
				
				//	Button Control
				fnButtonControl();
				
				//	If header is null
				if ( result.header != null && result.header.length > 0 ) {
					dynamicLayout.push({
							headerText : "Stock",
							children :
								[
								 {
									 dataField : result.header[0].planMasterIdH,
									 headerText :"<spring:message code='sys.scm.salesplan.PlanMasterId' />",
									 editable : true,
									 visible : true,
									 width : 0
								 }, {
									 dataField : result.header[0].checkFlag,
									 headerText : "chk",
									 editable : true,
									 visible : false
								 }, {
									 dataField : result.header[0].teamH1,
									 headerText : "<spring:message code='sys.scm.salesplan.Team' />",
									 editable : true
								 }, {
									 dataField : result.header[0].stkTypeIdH1,
									 headerText : "<spring:message code='sys.scm.interface.stockType' />",
									 editable : true
								 }, {
									 dataField : result.header[0].categoryH1,
									 headerText : "<spring:message code='sys.scm.salesplan.Category' />",
									 editable : true
								 }, {
									 dataField : result.header[0].codeH1,
									 headerText : "<spring:message code='sys.scm.salesplan.Code' />",
									 editable : true
								 }, {
									 dataField : result.header[0].nameH1,
									 headerText : "<spring:message code='sys.scm.salesplan.Name' />",
									 editable : true
								 }
								 ]
							}, {
								//	M-3 AVG
								dataField : result.header[0].isuueorderH,
								headerText : "<spring:message code='sys.scm.salesplan.M3_AVG_IssueOrder' />",
								editable : false
							}, {
								headerText : "Monthly",
								children :
									[
									//	for insert start
									 {
										 dataField : "scmGrYear",
										 headerText : "<spring:message code='budget.Year' />",
										 editable : false,
										 width : 0,
										 visible : false
									 }, {
										 dataField : "scmGrWeek",
										 headerText : "<spring:message code='sys.scm.pomngment.EstWeek' />",
										 editable : false,
										 width : 0,
										 visible : false
									 }, {
										 dataField : "preM3AvgOrded",
										 headerText : "<spring:message code='sys.scm.salesplan.preM3AvgOrded' />",
										 editable : true,
										 width : "13%",
										 visible : false,
										 style : "my-editable"
									 }, {
										 dataField : "preM3AvgIssu",
										 headerText : "<spring:message code='sys.scm.salesplan.preM3AvgIssu' />",
										 editable : true,
										 width : "13%",
										 visible : false,
										 style : "my-editable"
									 }, {
										 dataField : "newStockTypeId",
										 headerText : "NEW_STOCK_TYPE_ID",
										 editable : true,
										 width : "13%",
										 visible : false,
										 style : "my-editable"
									 }, {
										 dataField : "newStockCode",
										 headerText : "NEW_STOCK_CODE",
										 editable : true,
										 width : "13%",
										 visible : false,
										 style : "my-editable"
									 }, {
										 dataField : "m1Ord",
										 headerText : "<spring:message code='sys.scm.salesplan.m1Ord' />",
										 editable : true,
										 width : "5%",
										 visible : false,
										 style : "my-editable"
									 }, {
										 dataField : "m2Ord",
										 headerText : "<spring:message code='sys.scm.salesplan.m2Ord' />",
										 editable : true,
										 width : "5%",
										 visible : false,
										 style : "my-editable"
									 }, {
										 dataField : "m3Ord",
										 headerText : "<spring:message code='sys.scm.salesplan.m3Ord' />",
										 editable : true,
										 width : "5%",
										 visible : false,
										 style : "my-editable"
									 }, {
										 dataField : "m33",
										 headerText : "<spring:message code='sys.scm.salesplan.m33' />",
										 editable : true,
										 width : "5%",
										 visible : false,
										 style : "my-editable"
									 }, {
										 dataField : "m22",
										 headerText : "<spring:message code='sys.scm.salesplan.m22' />",
										 editable : true,
										 width : "5%",
										 visible : false,
										 style : "my-editable"
									 }, {
										 dataField : "m11",
										 headerText : "<spring:message code='sys.scm.salesplan.m11' />",
										 editable : true,
										 width : "5%",
										 visible : false,
										 style : "my-editable"
									 }, {
										 dataField : "m0Plan",
										 headerText : "<spring:message code='sys.scm.salesplan.m0Plan' />",
										 editable : true,
										 width : "5%",
										 visible : false,
										 style : "my-editable"
									 }, {
										 dataField : "m0Ord",
										 headerText : "<spring:message code='sys.scm.salesplan.m0Ord' />",
										 editable : true,
										 width : "5%",
										 visible : false,
										 style : "my-editable"
									//	for insert end
									 }, {
										 dataField : result.header[0].beforeDayH2,
										 headerText : "<spring:message code='sys.scm.salesplan.M1_issue_IssueOrder' />",
										 editable : false
									 }, {
										 dataField : result.header[0].todayH2,
										 headerText : "<spring:message code='sys.scm.salesplan.M0_PLN_ORD' />",
										 editable : false
									 }, {
										 dataField : result.header[0].m1H2,
										 headerText : "<spring:message code='sys.scm.salesplan.M1' />",
										 editable : false
									 }, {
										 dataField : result.header[0].m2H2,
										 headerText : "<spring:message code='sys.scm.salesplan.M2' />",
										 editable : false
									 }, {
										 dataField : result.header[0].m3H3,
										 headerText : "<spring:message code='sys.scm.salesplan.M3' />",
										 editable : false
									 }, {
										 dataField : result.header[0].m4H4,
										 headerText : "<spring:message code='sys.scm.salesplan.M4' />",
										 editable : false
									 }
									 ]
							}
					);
					
					var iM0TotCnt	= parseInt(result.seperaionInfo[0].m0TotCnt);
					var iM1TotCnt	= parseInt(result.seperaionInfo[0].m1TotCnt);
					var iM2TotCnt	= parseInt(result.seperaionInfo[0].m2TotCnt);
					var iM3TotCnt	= parseInt(result.seperaionInfo[0].m3TotCnt);
					
					var iLootCnt	= 1;
					var iLootDataFieldCnt	= 0;
					var intToStrFieldCnt	= "";
					var fieldStr	= "";
					var startCnt	= 0;
					var strWeekTh	= "W";
					
					/////////////////////////////////
					//	M + 0 : This Month	remainCnt
					var groupM_0	= {
							dataField : "M+0",
							headerText : "M+0",
							//headerText : "<spring:message code='sys.scm.salesplan.M0' />",
							children : []
					};
					for ( var i = 0 ; i < iM0TotCnt ; i++ ) {
						intToStrFieldCnt	= iLootDataFieldCnt.toString();
						
						if ( 1 == intToStrFieldCnt.length ) {
							intToStrFieldCnt	= "0" + intToStrFieldCnt;
						}
						if ( 0 == i ) {
							startCnt	= parseInt(result.getChildField[i].weekTh);
						} else {
							startCnt	= startCnt + 1;
						}
						if ( startCnt <  parseInt(gWeekThValue) ) {
							if ( startCnt.toString().length < 2 ) {
								strWeekTh	= "W0";
							} else {
								strWeekTh	= "W";
							}
							
							sumWeekThStr	= "bef" + (i+1) + "WeekTh";
							fieldStr		= "w" + iLootCnt + "WeekSeq";
							
							groupM_0.children.push({
								dataField :  sumWeekThStr,
								headerText : result.header[0][fieldStr],
								dataType : "numeric",
								formatString : "#,##0",
								editable : false,
								style : "my-backColumn1"
							});
							
							iLootCnt++;
							
							continue;
						} else if ( startCnt ==  parseInt(gWeekThValue) ) {
							fieldStr	= "w" + iLootCnt + "WeekSeq";
							
							groupM_0.children.push({
								dataField : "w" + intToStrFieldCnt,	//	"w00"
								headerText : result.header[0][fieldStr],
								dataType : "numeric",
								formatString : "#,##0",
								editable : false,
								style : "my-backColumn2"
							});
							
							iLootCnt++;
						} else {
							fieldStr	= "w" + iLootCnt + "WeekSeq";
							
							groupM_0.children.push({
								dataField : "w" + intToStrFieldCnt,	//	"w00"
								headerText : result.header[0][fieldStr],
								dataType : "numeric",
								formatString : "#,##0",
								style : "my-column"
							});
							
							iLootCnt++;
						}
						
						iLootDataFieldCnt++;
					}
					
					dynamicLayout.push(groupM_0);
					
					////////////////////////////
					//	M + 1
					var groupM_1	= {
							dataField : "M+1",
							headerText : "M+1",
							children : []
					};
					
					for ( var i = 0 ; i < iM1TotCnt ; i++ ) {
						intToStrFieldCnt	= iLootDataFieldCnt.toString();
						
						if ( 1 == intToStrFieldCnt.length ) {
							intToStrFieldCnt	= "0" + intToStrFieldCnt;
						}
						fieldStr	= "w" + iLootCnt + "WeekSeq";
						
						groupM_1.children.push({
							dataField : "w" + intToStrFieldCnt,
							headerText :  result.header[0][fieldStr],
							dataType : "numeric",
							formatString : "#,##0",
							style : "my-column",
						});
						
						iLootCnt ++;
						iLootDataFieldCnt++;
					}
					dynamicLayout.push(groupM_1);
					
					////////////////////////////
					//	M + 2
					var groupM_2	= {
							dataField : "M+2",
							headerText : "M+2",
							children : []
					};
					
					for ( var i = 0 ; i < iM2TotCnt ; i++ ) {
						intToStrFieldCnt	= iLootDataFieldCnt.toString();
						
						if ( 1 == intToStrFieldCnt.length ) {
							intToStrFieldCnt	= "0" + intToStrFieldCnt;
						}
						fieldStr	= "w" + iLootCnt + "WeekSeq";
						
						groupM_2.children.push({
							dataField : "w" + intToStrFieldCnt,
							headerText :  result.header[0][fieldStr],
							dataType : "numeric",
							formatString : "#,##0",
							style : "my-column",
						});
						
						iLootCnt ++;
						iLootDataFieldCnt++;
					}
					dynamicLayout.push(groupM_2);
					
					////////////////////////////
					//	M + 3
					var groupM_3	= {
							dataField : "M+3",
							headerText : "M+3",
							children : []
					};
					
					for ( var i = 0 ; i < iM3TotCnt ; i++ ) {
						intToStrFieldCnt	= iLootDataFieldCnt.toString();
						
						if ( 1 == intToStrFieldCnt.length ) {
							intToStrFieldCnt	= "0" + intToStrFieldCnt;
						}
						fieldStr	= "w" + iLootCnt + "WeekSeq";
						
						groupM_3.children.push({
							dataField : "w" + intToStrFieldCnt,
							headerText :  result.header[0][fieldStr],
							dataType : "numeric",
							formatString : "#,##0",
							style : "my-column",
						});
						
						iLootCnt ++;
						iLootDataFieldCnt++;
					}
					dynamicLayout.push(groupM_3);
					
					myGridID	= AUIGrid.create("#dynamic_DetailGrid_wrap", dynamicLayout, dynamicOption);
					AUIGrid.bind(myGridID, "cellEditBegin", auiCellEditingHandler);
					AUIGrid.bind(myGridID, "cellEditEnd", auiCellEditingHandler);
					AUIGrid.bind(myGridID, "cellEditCancel", auiCellEditingHandler);
					AUIGrid.bind(myGridID, "addRow", auiAddRowHandler);
					AUIGrid.bind(myGridID, "removeRow", auiRemoveRowHandler);
					AUIGrid.bind(myGridID, "cellClick", function(event) {
						gSelMainRowIdx	= event.rowIndex;
						console.log("CellClick rowIndex : " + event.rowIndex + ", columnIndex : " + event.columnIndex + " clickedAuthId: " + $("#selAuthId").val() );
						/*var header	= AUIGrid.getCellValue(myGridID, 0, event.columnIndex);
						var header1	= AUIGrid.getCellValue(myGridID, 1, event.columnIndex);
						console.log("clicked header : " + header + "--------------------------------------");
						console.log("clicked header1 : " + header1 + "--------------------------------------");
						var header2	= "";
						console.log("=========== : " + parseInt(28) + parseInt(gM0));
						if ( event.columnIndex >= 28 && event.columnIndex < parseInt(28) + parseInt(gM0) ) {
							//	M+0 합계
							
						} else if ( event.columnIndex >= event.columnIndex && event.columnIndex < parseInt(28) + parseInt(gM0) + parseInt(gM1) ) {
							//	M+1 합계
							var	m1Sum	= AUIGrid.getCellValue(myGridID,
						}*/
					});
					AUIGrid.bind(myGridID, "cellDoubleClick", function(event) {
						console.log("DobleClick ( " + event.rowIndex + ", " + event.columnIndex + ") :  " + " value: " + event.value );
					});
					AUIGrid.bind(myGridID, "rowAllChkClick", function(event) {
						if ( event.checked ) {
							var uniqueValues	= AUIGrid.getColumnDistinctValues(event.pid, "checkFlag");
							AUIGrid.setCheckedRowsByValue(event.pid, "checkFlag", 1);
						} else {
							AUIGrid.setCheckedRowsByValue(event.pid, "checkFlag", 0);
						}
					});
					
					fnSearchBtnList();
				}
			}
			, function(jqXHR, textStatus, errorThrown) {
				try {
					console.log("HeaderFail Status : " + jqXHR.status);
					console.log("code : "        + jqXHR.responseJSON.code);
					console.log("message : "     + jqXHR.responseJSON.message);
					console.log("detailMessage : "  + jqXHR.responseJSON.detailMessage);
				} catch ( e ) {
					console.log(e);
				}
				Common.alert("Fail : " + jqXHR.responseJSON.message);
			});
}



//trim
String.prototype.fnTrim = function()
{
    return this.replace(/(^\s*)|(\s*$)/gi, "");
}

function fnSelectStockIdByStCode(paramStockCode, paramStockTypeId)
{
	var stkId = "";

   Common.ajaxSync("GET", "/scm/selectStockIdByStCode.do"
           , {  newStockCode   : paramStockCode
              , newStockTypeId : paramStockTypeId
             }
           , function(result)
           {
              if(result.selectStockIdByStCode.length > 0)
              {
            	  stkId = String(result.selectStockIdByStCode[0].stkId);
              }

           });

   return stkId;
}

function fnGetDetailAndSeqMstId()
{
   Common.ajax("GET", "/scm/selectPlanMstIdDetailSeqForIns.do"
           , $("#MainForm").serialize()
           , function(result)
           {
              var gplanDtlIdSeq = parseInt(result.selectPlanDetailIdSeq[0].scm0002dPlanDtlIdSeq);  // seq
              var gplanMasterId = parseInt(result.selectPlanMasterId[0].planMasterId);

              if(result != null && result.length > 0)
              {
            	  //console.log("성공 SearchBtnData_dtlSeq : " + gplanDtlIdSeq);
              }
           });
}

function fnGetMonthInfo()
{
   Common.ajax("GET", "/scm/selectPlanId.do"
           , $("#MainForm").serialize()
           , function(result)
           {
              //console.log("성공 SearchBtnData_planId : " + result.planMonth);
              if(result != null && result.length > 0)
              {
               $("#selectPlanMonth").val(result.planMonth);
              }
           });
}

/*
function selectStockCtgrySummaryList()
{
	  var params = {
		      stkCategories : $('#stockCategoryCbBox').multipleSelect('getSelects'),
		      scmStockTypes : $('#scmStockType').multipleSelect('getSelects'),
		      stkCodes : $('#stockCodeCbBox').multipleSelect('getSelects')
		      };

	 params = $.extend($("#MainForm").serializeJSON(), params);

   Common.ajax("POST"
			       , "/scm/selectStockCtgrySummary.do"
	           , params
	           , function(result)
	           {
	              //console.log("성공 selectStockCtgrySummary: " + result.selectSalesSummaryList);
	              //AUIGrid.setGridData(summaryGridID, result.selectSalesSummaryList);
	              if(result != null && result.length > 0)
	              {
	              }
	           });

}
*/
function fnSearchBtnList() {
	var params	= {
			stkCategories : $("#stockCategoryCbBox").multipleSelect("getSelects"),
			scmStockTypes : $("#scmStockType").multipleSelect("getSelects"),
			stkCodes : $("#stockCodeCbBox").multipleSelect("getSelects")
	}
	params	= $.extend($("#MainForm").serializeJSON(), params);
	
	Common.ajax("POST"
			, "/scm/selectSalesPlanMngmentSearch.do"
			, params
			, function(result) {
				console.log("성공 fnSearchBtnList: " + result.length);
				console.log(result);
				
				if ( result.planInfo != null && result.planInfo.length > 0 ) {
					for ( var i = 0 ; i < result.planInfo.length ; i++ ) {
						if ( "DST" == result.planInfo[i].team ) {
							$("#planYear1").text(result.planInfo[i].planYear);
							$("#planMonth1").text(result.planInfo[i].planMonth);
							$("#planWeek1").text(result.planInfo[i].planWeek);
							$("#planTeam1").text(result.planInfo[i].team);
							$("#planStatus1").text(result.planInfo[i].planStusNm);
							$("#planCreatedAt1").text(result.planInfo[i].crtDt);
							$("#planId1").val(result.planInfo[i].planId);
							$("#planStusId1").val(result.planInfo[i].planStusId);
							$("#created1").val(result.planInfo[i].created);
						} else if ( "CODY" == result.planInfo[i].team ) {
							$("#planYear2").text(result.planInfo[i].planYear);
							$("#planMonth2").text(result.planInfo[i].planMonth);
							$("#planWeek2").text(result.planInfo[i].planWeek);
							$("#planTeam2").text(result.planInfo[i].team);
							$("#planStatus2").text(result.planInfo[i].planStusNm);
							$("#planCreatedAt2").text(result.planInfo[i].crtDt);
							$("#planId2").val(result.planInfo[i].planId);
							$("#planStusId2").val(result.planInfo[i].planStusId);
							$("#created2").val(result.planInfo[i].created);
						} else if ( "CS" == result.planInfo[i].team ) {
							$("#planYear3").text(result.planInfo[i].planYear);
							$("#planMonth3").text(result.planInfo[i].planMonth);
							$("#planWeek3").text(result.planInfo[i].planWeek);
							$("#planTeam3").text(result.planInfo[i].team);
							$("#planStatus3").text(result.planInfo[i].planStusNm);
							$("#planCreatedAt3").text(result.planInfo[i].crtDt);
							$("#planId3").val(result.planInfo[i].planId);
							$("#planStusId3").val(result.planInfo[i].planStusId);
							$("#created3").val(result.planInfo[i].created);
						}
					}
					fnButtonControl();
				} else {
					console.log("planInfo is null !!!!!");
				}
				
				//	set seperation info
				gM0	= result.seperationInfo[0].m0TotCnt;
				gM1	= result.seperationInfo[0].m1TotCnt;
				gM2	= result.seperationInfo[0].m2TotCnt;
				gM3	= result.seperationInfo[0].m3TotCnt;
				//gM0	= result.seperationInfo[0].m4TotCnt;
				console.log("=========== M0 cnt : " + gM0);
				AUIGrid.setGridData(myGridID, result.salesPlanMainList);
			});
}

function fnSelectSalesCnt(inputCode)
{
   Common.ajax("GET", "/scm/selectSalesCnt.do"
           , { stockCode: inputCode }
           , function(result)
           {
              //console.log("성공 selectSalesCnt: " + result[0].saleCnt );
              if(result != null && result.length > 0)
              {
              }
           });
}

function fnChangeEventPeriod(object)
{
	gWeekThValue = object.value;
}


/****************************  Form Ready ******************************************/

var myGridID;// , summaryGridID;

$(document).ready(function()
{
    $("#zreExptId").focus();

    $("#zreExptId").keydown(function(key)
    {
       if (key.keyCode == 13)
       {
         fnSearchBtnList();
       }

    });

    $("#zreExptId").bind("keyup", function()
    {
      $(this).val($(this).val().toUpperCase());
    });

    $("#dealerName").keydown(function(key)
    {
       if (key.keyCode == 13)
       {
         fnSearchBtnList();
       }
    });

    $("#dealerName").bind("keyup", function()
    {
      $(this).val($(this).val().toUpperCase());
    });


    /********************/

});   //$(document).ready


//	change team
function fnButtonControl(create) {
	var scmTeamCbBox	= $("#scmTeamCbBox").val();
	console.log("=========== scmTeam : " + scmTeamCbBox);
	console.log("=========== planId1 : " + $("#planId1").val());
	console.log("=========== planId2 : " + $("#planId2").val());
	console.log("=========== planId3 : " + $("#planId3").val());
	console.log("=========== planStusId1 : " + $("#planStusId1").val());
	console.log("=========== planStusId2 : " + $("#planStusId2").val());
	console.log("=========== planStusId3 : " + $("#planStusId3").val());

	if ( "" == scmTeamCbBox ) {
		//	Team : All -> All Button disabled
		$("#btnCreate").addClass("btn_disabled");
		$("#btnConfirm").addClass("btn_disabled");
		$("#btnUnconfirm").addClass("btn_disabled");
		$("#btnSave").addClass("btn_disabled");
		//$("#btnExcel").addClass("btn_disabled");
	} else if ( "DST" == scmTeamCbBox ) {
		if ( "" != $("#planId1").val() ) {
			//	created
			$("#btnCreate").addClass("btn_disabled");
			if ( "1" == $("#planStusId1").val() ) {
				//	confirmed
				$("#btnConfirm").addClass("btn_disabled");
				$("#btnUnconfirm").removeClass("btn_disabled");
				$("#btnSave").addClass("btn_disabled");
				//$("#btnExcel").removeClass("btn_disabled");
			} else if ( "4" == $("#planStusId1").val() ) {
				//	unconfirmed
				$("#btnConfirm").removeClass("btn_disabled");
				$("#btnUnconfirm").addClass("btn_disabled");
				$("#btnSave").removeClass("btn_disabled");
				//$("#btnExcel").removeClass("btn_disabled");
			}
		} else {
			//	not created
			$("#btnCreate").removeClass("btn_disabled");
			$("#btnConfirm").addClass("btn_disabled");
			$("#btnUnconfirm").addClass("btn_disabled");
			$("#btnSave").addClass("btn_disabled");
			//$("#btnExcel").addClass("btn_disabled");
		}
	} else if ( "CODY" == scmTeamCbBox ) {
		if ( "" != $("#planId2").val() ) {
			//	created
			$("#btnCreate").addClass("btn_disabled");
			if ( "1" == $("#planStusId2").val() ) {
				//	confirmed
				$("#btnConfirm").addClass("btn_disabled");
				$("#btnUnconfirm").removeClass("btn_disabled");
				$("#btnSave").addClass("btn_disabled");
				//$("#btnExcel").removeClass("btn_disabled");
			} else if ( "4" == $("#planStusId2").val() ) {
				//	unconfirmed
				$("#btnConfirm").removeClass("btn_disabled");
				$("#btnUnconfirm").addClass("btn_disabled");
				$("#btnSave").removeClass("btn_disabled");
				//$("#btnExcel").removeClass("btn_disabled");
			}
		} else {
			//	not created
			$("#btnCreate").removeClass("btn_disabled");
			$("#btnConfirm").addClass("btn_disabled");
			$("#btnUnconfirm").addClass("btn_disabled");
			$("#btnSave").addClass("btn_disabled");
			//$("#btnExcel").addClass("btn_disabled");
		}
	} else if ( "CS" == scmTeamCbBox ) {
		if ( "" != $("#planId3").val() ) {
			//	created
			$("#btnCreate").addClass("btn_disabled");
			if ( "1" == $("#planStusId3").val() ) {
				//	confirmed
				$("#btnConfirm").addClass("btn_disabled");
				$("#btnUnconfirm").removeClass("btn_disabled");
				$("#btnSave").addClass("btn_disabled");
				//$("#btnExcel").removeClass("btn_disabled");
			} else if ( "4" == $("#planStusId3").val() ) {
				//	unconfirmed
				$("#btnConfirm").removeClass("btn_disabled");
				$("#btnUnconfirm").addClass("btn_disabled");
				$("#btnSave").removeClass("btn_disabled");
				//$("#btnExcel").removeClass("btn_disabled");
			}
		} else {
			//	not created
			$("#btnCreate").removeClass("btn_disabled");
			$("#btnConfirm").addClass("btn_disabled");
			$("#btnUnconfirm").addClass("btn_disabled");
			$("#btnSave").addClass("btn_disabled");
			//$("#btnExcel").addClass("btn_disabled");
		}
	}
	
	if ( "Y" == create ) {
		$("#btnCreate").removeClass("btn_disabled");
	}
}

</script>

<section id="content"><!-- content start -->
<ul class="path">
	<li><img src="${pageContext.request.contextPath}/resources/images/common/path_home.gif" alt="Home" /></li>
	<li>Sales</li>
	<li>Order list</li>
</ul>

<aside class="title_line"><!-- title_line start -->
<p class="fav"><a href="javascript:void(0);" class="click_add_on">My menu</a></p>
<h2>Sales Plan Management</h2>
<ul class="right_btns">
	<li><p class="btn_blue"><a onclick="fnSettiingHeader();"><span class="search"></span>Search</a></p></li>
</ul>
</aside><!-- title_line end -->

<section class="search_table"><!-- search_table start -->
<form id="MainForm" method="get" action="">
	<input type="hidden" id="planId1" name="planId1" value=""/>
	<input type="hidden" id="planId2" name="planId2" value=""/>
	<input type="hidden" id="planId3" name="planId3" value=""/>
	<input type="hidden" id="planStusId1" name="planStusId1" value=""/>
	<input type="hidden" id="planStusId2" name="planStusId2" value=""/>
	<input type="hidden" id="planStusId3" name="planStusId3" value=""/>
	<input type="hidden" id="created1" name="created1" value=""/>
	<input type="hidden" id="created2" name="created2" value=""/>
	<input type="hidden" id="created3" name="created3" value=""/>
	<input type="hidden" id="selectPlanMonth" name="selectPlanMonth" value=""/>
	<table class="type1"><!-- table start -->
	<caption>table</caption>
	<colgroup>
		<col style="width:140px" />
		<col style="width:*" />
		<col style="width:70px" />
		<col style="width:*" />
		<col style="width:100px" />
		<col style="width:*" />
	</colgroup>
	<tbody>
	<tr>
		<th scope="row">EST Year &amp; Week</th>
		<td>
			<div class="date_set w100p"><!-- date_set start -->
				<select class="sel_year" id="scmYearCbBox" name="scmYearCbBox"></select>
				<select class="sel_date" id="scmPeriodCbBox" name="scmPeriodCbBox" onchange="fnChangeEventPeriod(this);"></select>
			</div><!-- date_set end -->
		</td>
		<th scope="row">Team</th>
		<td colspan="3">
			<select class="w100p" id="scmTeamCbBox" name="scmTeamCbBox" onchange="fnButtonControl();"></select>
		</td>
	</tr>
	<tr>
		<th scope="row">Stock Category</th>
		<td>
			<select class="w100p" id="stockCategoryCbBox" multiple="multiple" name="stockCategoryCbBox"></select>
		</td>
		<th scope="row">Stock</th>
		<td>
			<select class="multy_select w100p" multiple="multiple" id="stockCodeCbBox" name="stockCodeCbBox"></select>
		</td>
		<th scope="row">Stock Type</th>
		<td>
			<select class="w100p" multiple="multiple" id="scmStockType" name="scmStockType"></select>
		</td>
	</tr>
	</tbody>
	</table><!-- table end -->

	<aside class="link_btns_wrap"><!-- link_btns_wrap start -->
	<p class="show_btn">
		<%-- <a href="javascript:void(0);"><img src="${pageContext.request.contextPath}/resources/images/common/btn_link.gif" alt="link show" /></a> --%>
	</p>
	<dl class="link_list">
		<dt>Link</dt>
		<dd>
		<ul class="btns">
			<li><p class="link_btn"><a href="javascript:void(0);">menu1</a></p></li>
			<li><p class="link_btn"><a href="javascript:void(0);">menu2</a></p></li>
			<li><p class="link_btn"><a href="javascript:void(0);">menu3</a></p></li>
			<li><p class="link_btn"><a href="javascript:void(0);">menu4</a></p></li>
			<li><p class="link_btn"><a href="javascript:void(0);">Search Payment</a></p></li>
			<li><p class="link_btn"><a href="javascript:void(0);">menu6</a></p></li>
			<li><p class="link_btn"><a href="javascript:void(0);">menu7</a></p></li>
			<li><p class="link_btn"><a href="javascript:void(0);">menu8</a></p></li>
		</ul>
		<ul class="btns">
			<li><p class="link_btn type2"><a href="javascript:void(0);">menu1</a></p></li>
			<li><p class="link_btn type2"><a href="javascript:void(0);">Search Payment</a></p></li>
			<li><p class="link_btn type2"><a href="javascript:void(0);">menu3</a></p></li>
			<li><p class="link_btn type2"><a href="javascript:void(0);">menu4</a></p></li>
			<li><p class="link_btn type2"><a href="javascript:void(0);">Search Payment</a></p></li>
			<li><p class="link_btn type2"><a href="javascript:void(0);">menu6</a></p></li>
			<li><p class="link_btn type2"><a href="javascript:void(0);">menu7</a></p></li>
			<li><p class="link_btn type2"><a href="javascript:void(0);">menu8</a></p></li>
		</ul>
		<p class="hide_btn"><a href="javascript:void(0);"><img src="${pageContext.request.contextPath}/resources/images/common/btn_link_close.gif" alt="hide" /></a></p>
		</dd>
	</dl>
	</aside><!-- link_btns_wrap end -->
</form>
</section><!-- search_table end -->

<section class="search_result"><!-- search_result start -->
<ul class="right_btns">
	<li><p id="btnCreate" class="btn_grid btn_disabled"><a onclick="fnCreate(this);">Create</a></p></li>
	<li><p id="btnConfirm" class="btn_grid btn_disabled"><a onclick="fnConfirm(this);">Confirm</a></p></li>
	<li><p id="btnUnconfirm" class="btn_grid btn_disabled"><a onclick="fnUnConfirm(this);">UnConfirm</a></p></li>
	<li><p id="btnSave" class="btn_grid btn_disabled"><a onclick="fnSave(this);">Save</a></p></li>
	<li><p id="btnExcel" class="btn_grid"><a onclick="fnExcel(this,'SalesPlanManagement');">Excel</a></p></li>
	<!-- <li><p id='btnExcel'  class="btn_grid btn_disabled"><a onclick="fnExcel(this,'SalesPlanManagement');">Download</a></p></li> -->
</ul>

<table class="type1 mt10"><!-- table start -->
<caption>table</caption>
<colgroup>
	<col style="width:90px" />
	<col style="width:*" />
	<col style="width:60px" />
	<col style="width:*" />
	<col style="width:60px" />
	<col style="width:*" />
	<col style="width:60px" />
	<col style="width:*" />
	<col style="width:120px" />
	<col style="width:90px" />
	<col style="width:160px" />
	<col style="width:150px" />
</colgroup>
<tbody>
	<tr><!-- Team DST -->
		<!-- <th scope="row">Year</th><td><span id="planYear1"></span></td>
		<th scope="row">Month</th><td><span id="planMonth1"></span></td>
		<th scope="row">Week</th><td><span id="planWeek1"></span></td> -->
		<th scope="row">Team</th><td colspan="3"><span id="planTeam1"></span></td>
		<th scope="row">Status</th><td colspan="3"><span id="planStatus1"></span></td>
		<th scope="row">Created At</th><td colspan="3"><span id="planCreatedAt1"></span></td>
		<!-- <th scope="row">Last Updated At</th><td><span id="lastUpdatedAt1"></span></td> -->
	</tr>
	<tr><!-- Team CODY -->
		<!-- <th scope="row">Year</th><td><span id="planYear2"></span></td>
		<th scope="row">Month</th><td><span id="planMonth2"></span></td>
		<th scope="row">Week</th><td><span id="planWeek2"></span></td> -->
		<th scope="row">Team</th><td colspan="3"><span id="planTeam2"></span></td>
		<th scope="row">Status</th><td colspan="3"><span id="planStatus2"></span></td>
		<th scope="row">Created At</th><td colspan="3"><span id="planCreatedAt2"></span></td>
		<!-- <th scope="row">Last Updated At</th><td><span id="lastUpdatedAt2"></span></td> -->
	</tr>
	<tr><!-- Team CS -->
		<!-- <th scope="row">Year</th><td><span id="planYear3"></span></td>
		<th scope="row">Month</th><td><span id="planMonth3"></span></td>
		<th scope="row">Week</th><td><span id="planWeek3"></span></td> -->
		<th scope="row">Team</th><td colspan="3"><span id="planTeam3"></span></td>
		<th scope="row">Status</th><td colspan="3"><span id="planStatus3"></span></td>
		<th scope="row">Created At</th><td colspan="3"><span id="planCreatedAt3"></span></td>
		<!-- <th scope="row">Last Updated At</th><td><span id="lastUpdatedAt3"></span></td> -->
	</tr>
</tbody>
</table><!-- table end -->

<br/>

<article class="grid_wrap"><!-- grid_wrap start -->
<!-- 그리드 영역 2-->
 <div id="dynamic_DetailGrid_wrap" style="height:600px;"></div>
</article><!-- grid_wrap end -->

</section><!-- search_result end -->
</section><!-- content end -->