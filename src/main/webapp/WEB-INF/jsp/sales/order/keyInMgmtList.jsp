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

var gAddRowCnt = 0;
var keyValueList = [];
var myGridID;
var oldRowIndex = -1;

$(document).ready(function(){

    var options = {
                  usePaging : true,
                  pageRowCount : 20,
                  fixedColumnCount : 1,
                  useGroupingPanel : false,
                  showRowNumColumn : false,
                  enableCellMerge : true,
                  editBeginMode : "click",
                  selectionMode : "multipleRows",
                  rowSelectionWithMerge : true,
                  softRemovePolicy : "exceptNew",
                  editable : true
                };


    var MainColumnLayout =
        [
            { dataField : "keyInId", headerText : 'keyInId', width : "10%", editable : false},
            { dataField : "keyInNo", headerText : 'keyInNo', width : "10%", editable : false},
            { dataField : "year", headerText : 'Year', width : "10%", editable : false },
            { dataField : "month", headerText : 'Month', width : "10%" },
            { dataField : "week", headerText : 'Weeks', width : "10%", editable : false },
            { dataField : "keyinStartDt", headerText : 'Key-In Start Date',  width : "15%",dataType : "date",
                formatString : "dd/mm/yyyy",
                editRenderer : {
                    type : "CalendarRenderer",
                    showEditorBtnOver : true,
                    onlyCalendar : true,
                    showExtraDays : true,
                    validator : function(oldValue, newValue, rowItem) {
                        var date, isValid = true;
                        var msg = "";

                        if(isNaN(Number(newValue)) ) {
                            if(isNaN(Date.parse(newValue))) {
                                isValid = false;
                                msg = "Invalid Date Type.";
                            } else {
                                isValid = true;
                            }
                        }

                        if(isValid){
                            var dtFrom = Number(rowItem.validDtFrom.toString().replace(/\//g,""));
                            var dtTo = Number(rowItem.validDtTo.toString().replace(/\//g,""));
                            if(dtFrom != 0 && dtTo != 0 && dtFrom > dtTo){
                                msg = "Start date can not be greater than End date.";
                                isValid = false;
                            }
                        }
                        return { "validate" : isValid, "message"  : msg };
                     }
                }
            },
            { dataField : "keyinStartTime", headerText : 'Key-In Start Time', width : "10%", editable : false },
            { dataField : "keyinEndDt", headerText : 'Key-In End Date',  width : "15%",dataType : "date",
                formatString : "dd/mm/yyyy",
                width:"12%",
                editRenderer : {
                    type : "CalendarRenderer",
                    showEditorBtnOver : true,
                    onlyCalendar : true,
                    showExtraDays : true,
                    validator : function(oldValue, newValue, rowItem) {
                        var date, isValid = true;
                        var msg = "";

                        if(isNaN(Number(newValue)) ) {
                            if(isNaN(Date.parse(newValue))) {
                                isValid = false;
                                msg = "Invalid Date Type.";
                            } else {
                                isValid = true;
                            }
                        }

                        if(isValid){
                            var dtFrom = Number(rowItem.validDtFrom.toString().replace(/\//g,""));
                            var dtTo = Number(rowItem.validDtTo.toString().replace(/\//g,""));
                            if(dtFrom != 0 && dtTo != 0 && dtFrom > dtTo){
                                msg = "Start date can not be greater than End date.";
                                isValid = false;
                            }
                        }
                        return { "validate" : isValid, "message"  : msg };
                     }
                }
            },
            { dataField : "keyinEndTime", headerText : 'Key-In End Time', width : "10%", editable : false },
            { dataField : "creator", headerText : 'Creator', width : "10%", editable : false },
            { dataField : "updator", headerText : 'Last Updator', width : "10%", editable : false },
            { dataField : "updDt", headerText : 'Last Update Date', width : "10%", editable : false }
        ];

    myGridID = GridCommon.createAUIGrid("grid_wrap", MainColumnLayout,"", options);

    // 20190902 KR-OHK : Add selectionChange event
    AUIGrid.bind(myGridID, "selectionChange", function(event) {
        var selectedItems = event.selectedItems;
        if(selectedItems.length <= 0) return;
        var firstItem = selectedItems[0];

        var primeCell = event.primeCell;
        var rowIndex = primeCell.rowIndex;

        oldRowIndex =  firstItem.rowIndex;
    });

    AUIGrid.bind(myGridID, "cellEditBegin", auiCellEditignHandler);
    AUIGrid.bind(myGridID, "cellEditEnd", auiCellEditignHandler);
    AUIGrid.bind(myGridID, "cellEditCancel", auiCellEditignHandler);
    AUIGrid.bind(myGridID, "removeRow", auiRemoveRowHandler);

    $("#delCancel").hide();

});

function auiCellEditignHandler(event)
{
  if(event.type == "cellEditBegin")
  {
      console.log("에디팅 시작(cellEditBegin) : ( " + event.rowIndex + ", " + event.columnIndex + " ) " + event.headerText + ", value : " + event.value);
      var today = new Date();

      var dd = today.getDate();
      var mm = today.getMonth() + 1;
      var yyyy = today.getFullYear();

      if (event.dataField == "month"){
          if (mm > event.value){
              return false;
          }
      }

      if (event.dataField == "keyinStartDt"){
    	  var startDate = new Date(event.value);
    	  var dd2 = startDate.getDate();
    	  var mm2 = startDate.getMonth() + 1;
    	  var yyyy2 = startDate.getFullYear();

          if (yyyy >= yyyy2 && mm > mm2 ){ //current date > value date
              return false;
          }
      }

      if (event.dataField == "keyinEndDt"){
    	  var endDate = new Date(event.value);
          var dd3 = endDate.getDate();
          var mm3 = endDate.getMonth() + 1;
          var yyyy3 = endDate.getFullYear();

          if (yyyy >= yyyy3 && mm > mm3 ){ //current date > value date
              return false;
          }
      }

  }
  else if(event.type == "cellEditEnd")
  {
      console.log("에디팅 종료(cellEditEnd) : ( " + event.rowIndex + ", " + event.columnIndex + " ) " + event.headerText + ", value : " + event.value);

      /* if (event.dataField == "pgmName" && event.headerText == "NAME" )
      {
          AUIGrid.setCellValue(myGridID, event.rowIndex, 4, event.value);
      }
      else if (event.dataField == "fromDtTypeId")
      {
          if(event.value == "") {
              AUIGrid.setCellValue(myGridID, event.rowIndex, 6, "");   // fromDtFieldNm
              AUIGrid.setCellValue(myGridID, event.rowIndex, 7, "");   // fromDtVal
          }
      }
      else if (event.dataField == "toDtTypeId")
      {
          if(event.value == "") {
              AUIGrid.setCellValue(myGridID, event.rowIndex, 9, "");    // toDtFieldNm
              AUIGrid.setCellValue(myGridID, event.rowIndex, 10, "");   // toDtVal
          }
      } */
  }
  else if(event.type == "cellEditCancel")
  {
      console.log("에디팅 취소(cellEditCancel) : ( " + event.rowIndex + ", " + event.columnIndex + " ) " + event.headerText + ", value : " + event.value);
  }

}

function auiRemoveRowHandler(event)
{
  console.log (event.type + " 이벤트 :  " + ", 삭제된 행 개수 : " + event.items.length + ", softRemoveRowMode : " + event.softRemoveRowMode);
}

//행 삭제 이벤트 핸들러
function auiRemoveRowHandlerDetail(event)
{
  console.log (event.type + " 이벤트상세 :  " + ", 삭제된 행 개수 : " + event.items.length + ", softRemoveRowMode : " + event.softRemoveRowMode);
}

//행 삭제 메소드
function removeRow()
{
    console.log("removeRow method")
    AUIGrid.removeRow(myGridID,"selectedIndex");
}

function fnValidationCheck()
{
    var result = true;
    var addList = AUIGrid.getAddedRowItems(myGridID);
    var udtList = AUIGrid.getEditedRowItems(myGridID);
    var delList = AUIGrid.getRemovedItems(myGridID);

    if (addList.length == 0  && udtList.length == 0 && delList.length == 0)
    {
      Common.alert("No Change");
      return false;
    }

    for (var i = 0; i < addList.length; i++)
    {
      var year  = addList[i].year;
      var month  = addList[i].month;
      var week  = addList[i].week;
      var keyinStartDt  = addList[i].keyinStartDt;
      var keyinEndDt  = addList[i].keyinEndDt;

        if (year == "" || year.length == 0)
        {
          result = false;
          Common.alert("<spring:message code='sys.msg.necessary' arguments='key in year' htmlEscape='false'/>");
          break;
        }

        if (month == "" || month.length == 0)
        {
          result = false;
          Common.alert("<spring:message code='sys.msg.necessary' arguments='key in month' htmlEscape='false'/>");
          break;
        }

        if (week == "" || week.length == 0)
        {
          result = false;
          Common.alert("<spring:message code='sys.msg.necessary' arguments='key in week' htmlEscape='false'/>");
          break;
        }

        if (keyinStartDt == "" || keyinStartDt.length == 0)
        {
          result = false;
          Common.alert("<spring:message code='sys.msg.necessary' arguments='key in start Date' htmlEscape='false'/>");
          break;
        }

        if (keyinEndDt == "" || keyinEndDt.length == 0)
        {
          result = false;
          Common.alert("<spring:message code='sys.msg.necessary' arguments='key in end date' htmlEscape='false'/>");
          break;
        }
    }

    for (var i = 0; i < udtList.length; i++)
    {
    	 var year  = udtList[i].year;
         var month  = udtList[i].month;
         var week  = udtList[i].week;
         var keyinStartDt  = udtList[i].keyinStartDt;
         var keyinEndDt  = udtList[i].keyinEndDt;

        if (year == "" || year.length == 0)
        {
          result = false;
          Common.alert("<spring:message code='sys.msg.necessary' arguments='key in year' htmlEscape='false'/>");
          break;
        }

        if (month == "" || month.length == 0)
        {
          result = false;
          Common.alert("<spring:message code='sys.msg.necessary' arguments='key in month' htmlEscape='false'/>");
          break;
        }

        if (week == "" || week.length == 0)
        {
          result = false;
          Common.alert("<spring:message code='sys.msg.necessary' arguments='key in week' htmlEscape='false'/>");
          break;
        }

        if (keyinStartDt == "" || keyinStartDt.length == 0)
        {
          result = false;
          Common.alert("<spring:message code='sys.msg.necessary' arguments='key in start Date' htmlEscape='false'/>");
          break;
        }

        if (keyinEndDt == "" || keyinEndDt.length == 0)
        {
          result = false;
          Common.alert("<spring:message code='sys.msg.necessary' arguments='key in end date' htmlEscape='false'/>");
          break;
        }
    }

    for (var i = 0; i < delList.length; i++)
    {

    }

    return result;
}

function fnSaveId()
{
  if (fnValidationCheck() == false)
  {
	  console.log("pass");
    return false;
  }

   Common.ajax("POST", "/sales/keyInMgmt/saveKeyInId.do" , GridCommon.getEditData(myGridID) , function(result) {
            Common.alert(result.data  + "<spring:message code='sys.msg.savedCnt'/>");
            fnSelectKeyinListAjax() ;

            console.log("성공." + JSON.stringify(result));
            console.log("data : " + result.data);
         }
         , function(jqXHR, textStatus, errorThrown) {
	          try{
	            console.log("Fail Status : " + jqXHR.status);
	            console.log("code : "        + jqXHR.responseJSON.code);
	            console.log("message : "     + jqXHR.responseJSON.message);
	            console.log("detailMessage : "  + jqXHR.responseJSON.detailMessage);
	          }
	          catch (e) {
	            console.log(e);
	          }
	          alert("Fail : " + jqXHR.responseJSON.message);
        });
}

function cellStyleFunction(rowIndex, columnIndex, value, headerText, item, dataField){
    if(value != null)
    {
      return "aui-grid-left-column";
    }
    else
    {
        return null;
    }
}

function removeAllCancel()
{
    $("#delCancel").hide();

    AUIGrid.restoreSoftRows(myGridID, "all");
}

function fnSetPgmIdParamSet(myGridID, rowIndex)
{
    $("#keyInId").val(AUIGrid.getCellValue(myGridID, rowIndex, "keyInId"));
    $("#keyInNo").val(AUIGrid.getCellValue(myGridID, rowIndex, "keyInNo"));
}

function fnSelectKeyinListAjax()
{
     Common.ajax("GET", "/sales/keyInMgmt/searchKeyinMgmtList.do" , $("#MainForm").serialize() , function(result) {
                  console.log("성공 data : " + result);
                  AUIGrid.setGridData(myGridID, result);
                  oldRowIndex = -1; // 20190911 KR-OHK Initialize Variables
               });
}

function fn_New(){

    Common.popupDiv("/sales/keyInMgmt/keyInMgmtUploadPop.do" ,null, null , true , '_NewAddDiv1');
}

</script>

    <section id="content">
      <!-- content start -->
      <ul class="path">
        <li><img src="${pageContext.request.contextPath}/resources/images/common/path_home.gif" alt="Home" /></li>
        <li>Sales</li>
        <li>Key-In Management list</li>
      </ul>

      <aside class="title_line">
        <!-- title_line start -->
        <p class="fav"><a href="#" class="click_add_on">My menu</a></p>
        <h2>Key-In Management</h2>
        <ul class="right_btns">
         <c:if test="${PAGE_AUTH.funcUserDefine1 == 'Y'}">
            <li><p class="btn_blue"><a href="javascript:void(0);" onclick="javasclipt:fn_New()"><span class="Update Request"></span>Upload</a></p></li>
        </c:if>
          <li>
            <p class="btn_blue"><a onclick="fnSelectKeyinListAjax();"><span class="search"></span>Search</a></p>
          </li>
        </ul>
      </aside>

      <section class="search_table">
        <!-- search_table start -->
        <form id="MainForm" method="get" action="">
            <input type="hidden" id="keyInId" name="keyInId" value="" />
            <input type="hidden" id="keyInNo" name="keyInNo" value="" />

          <table class="type1">
            <!-- table start -->
            <caption>table</caption>
            <colgroup>
              <col style="width:150px" />
              <col style="width:*" />
              <!--   <col style="width:150px" />
  <col style="width:*" /> -->
            </colgroup>
            <tbody>
              <tr>

              <th scope="row">Month / Year</th>
		        <td><p style="width: 70%;">
		        <input id="dateFrom" name="dateFrom" type="text"
		                                                title="기준년월" placeholder="MM/YYYY" class="j_date2 w30p" />
		                                                To
		        <input id="dateTo" name="dateTo" type="text"
		                                                title="기준년월" placeholder="MM/YYYY" class="j_date2 w30p" />
		        </p>
		        </td>
              </tr>
            </tbody>
          </table><!-- table end -->

          <aside class="link_btns_wrap">
            <!-- link_btns_wrap start -->
            <p class="show_btn">
              <%-- <a href="javascript:void(0);">
                <img src="${pageContext.request.contextPath}/resources/images/common/btn_link.gif" alt="link show" />
                </a> --%>
            </p>
        </form>
      </section><!-- search_table end -->

      <section class="search_result">
        <!-- search_result start -->

        <aside class="title_line">
          <!-- title_line start -->
          <h3 class="pt0">Program List</h3>
          <ul class="right_opt">
            <li id="delCancel">
              <p class="btn_grid"><a onclick="removeAllCancel();">Cancel</a></p>
            </li>
            <li>
              <p class="btn_grid"><a onclick="removeRow();">DEL</a></p>
            </li>
            <li>
              <p class="btn_grid"><a onclick="fnSaveId();">SAVE</a></p>
            </li>
          </ul>
        </aside>

        <article class="grid_wrap">
          <div id="grid_wrap" style="height:290px;"></div>
        </article>

      </section>

    </section>