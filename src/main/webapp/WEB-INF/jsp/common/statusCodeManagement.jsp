<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>


<style type="text/css">
/* 칼럼 스타일 전체 재정의 */
.aui-grid-left-column {
  text-align:left;
}
</style>

<script type="text/javaScript">

var gSelRowIdx = 0;

var statusCategoryLayout = 
    [      
        {    
            dataField : "stusCtgryId",
            headerText : "<spring:message code='sys.status.grid1.CATEGORY_ID' />",
            width : "12%"
        }, {
            dataField : "stusCtgryName",
            headerText : "<spring:message code='sys.status.grid1.CATEGORY_NAME'/>",
            style : "aui-grid-left-column",
            width : "20%"
        }, {
            dataField : "stusCtgryDesc",
            headerText : "<spring:message code='sys.status.grid1.CATEGORY_DESCRIPTION'/>",
            style : "aui-grid-left-column",
            width : "22%"
        }, {
            dataField : "crtUserId",
            headerText : "<spring:message code='sys.status.grid1.CREATE_USER_ID'/>",
            width : "12%"
           ,editable : false
        }, {
            dataField : "updUserId",
            headerText : "<spring:message code='sys.status.grid1.LAST_UPDATE_USER_ID'/>",
            width : "16%"
           ,editable : false            
        }, {
            dataField : "updDt",
            headerText : "<spring:message code='sys.status.grid1.LAST_UPDATE'/>",
            dataType : "date",
            formatString : "dd-mmm-yyyy HH:MM:ss",
            width : "18%"
           ,editable : false
        }
    ];


var detailColumnLayout = 
    [  
        {
            dataField : "stusCodeId",
            headerText : "<spring:message code='sys.generalCode.grid1.CODE_ID'/>",
            width : "20%"
           ,editable : false
        }, {
            dataField : "codeName",
            headerText : "<spring:message code='sys.statuscode.grid1.CODE_NAME'/>",
            width : "60%"
           ,editable : false
        }, {
            dataField : "codeDisab",
            headerText : "<spring:message code='sys.generalCode.grid1.DISABLED'/>",
            width : "20%",
            visible : true,
            editRenderer : 
            {
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
    
var codeIDColumnLayout = 
    [ 
      {
          dataField : "checkFlag",
          headerText : '<input type="checkbox" id="allCheckbox" name="allCheckbox" style="width:15px;height:15px;">',
          width : "10%",
          editable : false,
          renderer : 
          {
              type : "CheckBoxEditRenderer",
              showLabel : false, // 참, 거짓 텍스트 출력여부( 기본값 false )
              editable : true, // 체크박스 편집 활성화 여부(기본값 : false)
              checkValue : 1, // true, false 인 경우가 기본
              unCheckValue : 0,
              // 체크박스 Visible 함수
              visibleFunction : function(rowIndex, columnIndex, value, isChecked, item, dataField) 
               {
                 if(item.checkFlag == 1)  // 1 이면
                 {
                  return true; // checkbox visible
                 }

                 return true;
               }
          }  //renderer
      },{
            dataField : "stusCodeId",
            headerText : "<spring:message code='sys.generalCode.grid1.CODE_ID'/>",
            width : "20%"
      },{
          dataField : "codeName",
          headerText : "<spring:message code='sys.statuscode.grid1.CODE_NAME'/>",
          style : "aui-grid-left-column",
          width : "50%"
      },{
          dataField : "code",
          headerText : "<spring:message code='sys.account.grid1.CODE'/>",
          width : "20%"
      }

    ];

// AUIGrid 메소드
//컬럼 선택시 상세정보 세팅.
function fnSetCategoryCd(selGrdidID, rowIdx)  
{     
   $("#selCategoryId").val(AUIGrid.getCellValue(selGrdidID, rowIdx, "stusCtgryId"));
   
   $("#paramCategoryId").val(AUIGrid.getCellValue(selGrdidID, rowIdx, "stusCtgryId"));
   
   console.log("selCategoryId: "+ $("#selCategoryId").val() + "paramCategoryId: "+ $("#paramCategoryId").val() + " stusCtgryName: " + AUIGrid.getCellValue(selGrdidID, rowIdx, "stusCtgryName") );                
}

function auiCellEditignHandler(event) 
{
    if(event.type == "cellEditBegin") 
    {
        console.log("에디팅 시작(cellEditBegin) : ( " + event.rowIndex + ", " + event.columnIndex + " ) " + event.headerText + ", value : " + event.value);
    } 
    else if(event.type == "cellEditEnd") 
    {
        console.log("에디팅 종료(cellEditEnd) : ( " + event.rowIndex + ", " + event.columnIndex + " ) " + event.headerText + ", value : " + event.value);
    } 
    else if(event.type == "cellEditCancel") 
    {
        console.log("에디팅 취소(cellEditCancel) : ( " + event.rowIndex + ", " + event.columnIndex + " ) " + event.headerText + ", value : " + event.value);
    }
  
}

//행 추가 이벤트 핸들러
function auiAddRowHandler(event) 
{
  console.log(event.type + " 이벤트\r\n" + "삽입된 행 인덱스 : " + event.rowIndex + "\r\n삽입된 행 개수 : " + event.items.length);
}

// MstGrid 행 추가, 삽입
function addRowCategory() 
{
  var item = new Object();

    item.stusCtgryId   ="";
    item.stusCtgryName ="";
    item.stusCtgryDesc ="";
    item.crtUserId     ="";  
    item.updUserId     ="";
    item.updDt         ="";
    // parameter
    // item : 삽입하고자 하는 아이템 Object 또는 배열(배열인 경우 다수가 삽입됨)
    // rowPos : rowIndex 인 경우 해당 index 에 삽입, first : 최상단, last : 최하단, selectionUp : 선택된 곳 위, selectionDown : 선택된 곳 아래
    AUIGrid.addRow(myGridID, item, "first");
}

function addRowStatusCode() 
{
  var item = new Object();
  item.checkFlag   = 0;
  item.stusCodeId  ="";
  item.codeName    ="";
  item.code        ="-";
    // parameter
    // item : 삽입하고자 하는 아이템 Object 또는 배열(배열인 경우 다수가 삽입됨)
    // rowPos : rowIndex 인 경우 해당 index 에 삽입, first : 최상단, last : 최하단, selectionUp : 선택된 곳 위, selectionDown : 선택된 곳 아래
    AUIGrid.addRow(statusCodeGridID, item, "first");
}

//행 삭제 이벤트 핸들러
function auiRemoveRowHandler(event) 
{
    console.log (event.type + " 이벤트 :  " + ", 삭제된 행 개수 : " + event.items.length + ", softRemoveRowMode : " + event.softRemoveRowMode);
}

//행 삭제 이벤트 핸들러
function auiRemoveRowHandlerDetail(event) 
{
    console.log (event.type + " 이벤트상세 :  " + ", 삭제된 행 개수 : " + event.items.length + ", softRemoveRowMode : " + event.softRemoveRowMode);
}

// 행 삭제 메소드
function removeRow() 
{
    console.log("removeRowMst: " + gSelRowIdx);    
    AUIGrid.removeRow(myGridID,gSelRowIdx);
}

//Make Use_yn ComboList, tooltip
function getDisibledComboList()
{     
  var list =  ["N", "Y"];   
  return list;
}

function fnGetCategoryCd(myGridID, rowIndex)
{
    fnSetCategoryCd(myGridID, rowIndex);
    fnSelectCategoryCdInfo();
}

//그리드 헤더 클릭 핸들러
function headerClickHandler(event) 
{
  // checkFlag 칼럼 클릭 한 경우
  if(event.dataField == "checkFlag") 
	{
    if(event.orgEvent.target.id == "allCheckbox") 
    { // 정확히 체크박스 클릭 한 경우만 적용 시킴.
      var  isChecked = document.getElementById("allCheckbox").checked;
      checkAll(isChecked);
    }
    return false;
  }
}

//전체 체크 설정, 전체 체크 해제 하기
function checkAll(isChecked) 
{
  var rowCount = AUIGrid.getRowCount(statusCodeGridID);

  if(isChecked)   // checked == true == 1
	{
	  for(var i=0; i<rowCount; i++) 
	  {
       AUIGrid.updateRow(statusCodeGridID, { "checkFlag" : 1 }, i);
    }
  } 
  else   // unchecked == false == 0
	{
	  for(var i=0; i<rowCount; i++) 
	  {
       AUIGrid.updateRow(statusCodeGridID, { "checkFlag" : 0 }, i);
    }
  }
  
  // 헤더 체크 박스 일치시킴.
  document.getElementById("allCheckbox").checked = isChecked;
  
  getItemsByCheckedField(statusCodeGridID);
  
}

function getItemsByCheckedField(selectedGrid) 
{
  // 체크된 item 반환
  var activeItems = AUIGrid.getItemsByValue(selectedGrid, "checkFlag", true);
  var checkedRowItem = [];
  var str = "";
  
  for(var i=0, len = activeItems.length; i<len; i++) 
	{
	    checkedRowItem = activeItems[i];
	    str += "chkRowIdx : " + checkedRowItem.rowIndex + ", chkId :" + checkedRowItem.stusCodeId + ", chkName : " + checkedRowItem.codeName  + "\n";
	}

  //alert("checked items: " + str);
  
}

//AUIGrid 생성 후 반환 ID
var myGridID, detailGridID, statusCodeGridID;

$(document).ready(function()
{
	  $("#paramCategoryId").focus();
	  
	  $("#paramCategoryId").keydown(function(key) 
	  {
			    if (key.keyCode == 13) 
			    {
			    	fnSelectCategoryListAjax();
			    }

		});
	  
	  $("#paramCategoryNM").keydown(function(key) 
	  {
			    if (key.keyCode == 13) 
			    {
			    	fnSelectCategoryListAjax();
			    }

		});
	  
	  $("#paramCreateID").keydown(function(key) 
	  {
			    if (key.keyCode == 13) 
			    {
			    	fnSelectCategoryListAjax();
			    }

		});

	  var options = {
                  usePaging : true,
                  useGroupingPanel : false,
                  showRowNumColumn : false  // 그리드 넘버링
                };
    
    // masterGrid 그리드를 생성합니다.
    myGridID = GridCommon.createAUIGrid("grid_wrap", statusCategoryLayout,"stusCtgryId", options);
    // AUIGrid 그리드를 생성합니다.
    
    // 푸터 객체 세팅
    //AUIGrid.setFooter(myGridID, footerObject);
    
    // 에디팅 시작 이벤트 바인딩
    AUIGrid.bind(myGridID, "cellEditBegin", auiCellEditignHandler);
    
    // 에디팅 정상 종료 이벤트 바인딩
    AUIGrid.bind(myGridID, "cellEditEnd", auiCellEditignHandler);
    
    // 에디팅 취소 이벤트 바인딩
    AUIGrid.bind(myGridID, "cellEditCancel", auiCellEditignHandler);
    
    // 행 추가 이벤트 바인딩 
    AUIGrid.bind(myGridID, "addRow", auiAddRowHandler);
    
    // 행 삭제 이벤트 바인딩 
    AUIGrid.bind(myGridID, "removeRow", auiRemoveRowHandler);


    // cellClick event.
    AUIGrid.bind(myGridID, "cellClick", function( event ) 
    {
        $("#selCategoryId").val("");
        $("#paramCategoryId").val(""); 
        gSelRowIdx = event.rowIndex;

        console.log("cellClick_Status: " + AUIGrid.isAddedById(myGridID,AUIGrid.getCellValue(myGridID, event.rowIndex, 0)) );

         if (AUIGrid.isAddedById(myGridID,AUIGrid.getCellValue(myGridID, event.rowIndex, 0)) == false)  // 추가된 행이 아니다.
         {
        	// Common.alert("<spring:message code='sys.msg.first.Select' arguments='Category ID' htmlEscape='false'/>");
           fnGetCategoryCd(myGridID, event.rowIndex);
         }
        
        console.log("CellClick rowIndex : " + event.rowIndex + ", columnIndex : " + event.columnIndex + " clickedCategoryId: " + $("#selCategoryId").val() +" / "+ $("#paramCategoryId").val());        
    });

 // 셀 더블클릭 이벤트 바인딩
    AUIGrid.bind(myGridID, "cellDoubleClick", function(event) 
    {
        console.log("DobleClick ( " + event.rowIndex + ", " + event.columnIndex + ") :  " + " value: " + event.value );
    });    

/***********************************************[ DETAIL GRID] ************************************************/

    var dtailOptions = 
        {
            usePaging : false,
            showRowNumColumn : false , // 그리드 넘버링
            useGroupingPanel : false,
            editable : true,
        };
 
    // detailGrid 생성
    detailGridID = GridCommon.createAUIGrid("detailGrid", detailColumnLayout,"stusCodeId", dtailOptions);

    // 에디팅 시작 이벤트 바인딩
    AUIGrid.bind(detailGridID, "cellEditBegin", auiCellEditignHandler);
    
    // 에디팅 정상 종료 이벤트 바인딩
    AUIGrid.bind(detailGridID, "cellEditEnd", auiCellEditignHandler);
    
    // 에디팅 취소 이벤트 바인딩
    AUIGrid.bind(detailGridID, "cellEditCancel", auiCellEditignHandler);
    
    // 행 추가 이벤트 바인딩 
    AUIGrid.bind(detailGridID, "addRow", auiAddRowHandler);
    
    // 행 삭제 이벤트 바인딩 
    AUIGrid.bind(detailGridID, "removeRow", auiRemoveRowHandlerDetail);
    
    // cellClick event.
    AUIGrid.bind(detailGridID, "cellClick", function( event ) 
    {
        console.log("CellClick rowIndex : " + event.rowIndex + ", columnIndex : " + event.columnIndex + " clicked");
        gSelRowIdx = event.rowIndex;
    });


    
    
/***********************************************[ CODE_ID GRID] ************************************************/

    var statusCodeOptions = 
        {
            usePaging : false,
            useGroupingPanel : false,
            editable : true,
            showRowNumColumn : false  // 그리드 넘버링
        };
 
    // detailGrid 생성
    statusCodeGridID = GridCommon.createAUIGrid("codeIdGrid", codeIDColumnLayout,"stusCodeId", statusCodeOptions);

    // 헤더 클릭 핸들러 바인딩
    AUIGrid.bind(statusCodeGridID, "headerClick", headerClickHandler);    

    // 에디팅 시작 이벤트 바인딩
    AUIGrid.bind(statusCodeGridID, "cellEditBegin", auiCellEditignHandler);
    
    // 에디팅 정상 종료 이벤트 바인딩
    AUIGrid.bind(statusCodeGridID, "cellEditEnd", auiCellEditignHandler);
    
    // 에디팅 취소 이벤트 바인딩
    AUIGrid.bind(statusCodeGridID, "cellEditCancel", auiCellEditignHandler);
    
    // 행 추가 이벤트 바인딩 
    AUIGrid.bind(statusCodeGridID, "addRow", auiAddRowHandler);
    
    // 행 삭제 이벤트 바인딩 
    AUIGrid.bind(statusCodeGridID, "removeRow", auiRemoveRowHandlerDetail);
    
    // cellClick event.
    AUIGrid.bind(statusCodeGridID, "cellClick", function( event ) 
    {
        console.log("CellClick rowIndex : " + event.rowIndex + ", columnIndex : " + event.columnIndex + " clicked");
        gSelRowIdx = event.rowIndex;
    });


    // 체크박스 클린 이벤트 바인딩  
    AUIGrid.bind(statusCodeGridID, "rowCheckClick", function( event ) {
      console.log("rowCheckClick : " + event.rowIndex + ", id : " + event.item.stusCodeId + ", name : " + event.item.codeName + ", checked : " + event.checked);
    });
    
    // 전체 체크박스 클릭 이벤트 바인딩
    AUIGrid.bind(statusCodeGridID, "rowAllChkClick", function( event ) {
      console.log("rowAllChkClick checked : " + event.checked);
    });
    

});   //$(document).ready


//ajax list 조회.
function fnSelectCategoryListAjax() 
{        
  Common.ajax("GET", "/status/selectStatusCategoryList.do"
       , $("#MainForm").serialize()
       , function(result) 
       {
          console.log("성공 data : " + result);
          AUIGrid.setGridData(myGridID, result);
          AUIGrid.clearGridData(detailGridID);
          
          if(result != null && result.length > 0)
          {
            fnGetCategoryCd(myGridID, 0);
            fnSelectStatusCdId();
          }
       });
}

function fnSelectCategoryCdInfo()
{
   Common.ajax("GET", "/status/selectStatusCategoryCdList.do"
        , $("#MainForm").serialize()
        , function(result) 
         {
             console.log("성공.");
             console.log("dataDetail : " + result);
             AUIGrid.setGridData(detailGridID, result);

             if(result == null || result.length == 0) 
             {
                 console.log("detail No data count");
             }
             
         });
}

function fnSelectStatusCdId() 
{        
  Common.ajax("GET", "/status/selectStatusCdIdList.do"
       , $("#MainForm").serialize()
       , function(result) 
       {
          console.log("성공 data : " + result);
          AUIGrid.setGridData(statusCodeGridID, result);
       });
}

function saveStatusCode()
{
  Common.ajax("POST", "/status/saveStatusCode.do"
	         , GridCommon.getEditData(statusCodeGridID)
	         , function(result) 
	           {
                fnSelectCategoryListAjax() ; 
		            console.log("saveCategory 성공.");
		            console.log("dataSuccess : " + result.data);
		            Common.alert(result.data  + "<spring:message code='sys.msg.savedCnt'/>");
	           } 

	         , function(jqXHR, textStatus, errorThrown) 
	           {
	              try 
	              {
	                console.log("Fail Status : " + jqXHR.status);
	                console.log("code : "        + jqXHR.responseJSON.code);
	                console.log("message : "     + jqXHR.responseJSON.message);
	                console.log("detailMessage : "  + jqXHR.responseJSON.detailMessage);
	              } 
	              catch (e) 
	              {
	                console.log(e);
	              }
	           
	              Common.alert("Fail : " + jqXHR.responseJSON.message);
	          }); 
  
}

function fnValidationCheck() 
{
    var result = true;
    var addList = AUIGrid.getAddedRowItems(myGridID);
    var udtList = AUIGrid.getEditedRowItems(myGridID);
        
    if (addList.length == 0  && udtList.length == 0 && delList.length == 0) 
    {
      Common.alert("No Change");
      return false;
    }

    for (var i = 0; i < addList.length; i++) 
    {
      var stusCtgryName  = addList[i].stusCtgryName;
      
      if (stusCtgryName == "" || stusCtgryName.length == 0) 
      {
        result = false;
        // {0} is required.
        Common.alert("<spring:message code='sys.msg.necessary' arguments='Category Name' htmlEscape='false'/>");
        break;
      }
    }

    for (var i = 0; i < udtList.length; i++) 
    {
      var stusCtgryName  = udtList[i].stusCtgryName;
      
      if (stusCtgryName == "" || stusCtgryName.length == 0) 
      {
        result = false;
        // {0} is required.
        Common.alert("<spring:message code='sys.msg.necessary' arguments='Category Name' htmlEscape='false'/>");
        break;
      }
    }

    return result;
}

function saveCategory()
{
	if (fnValidationCheck() == false)
  {
		  return false;
	}
	
  Common.ajax("POST", "/status/saveStatusCategory.do"
	       , GridCommon.getEditData(myGridID)
	       , function(result) 
	         {
            fnSelectCategoryListAjax() ;
	          console.log("saveCategory 성공.");
	          console.log("dataSuccess : " + result.data);
	          Common.alert(result.data  + "<spring:message code='sys.msg.savedCnt'/>"); 
	         } 

	       , function(jqXHR, textStatus, errorThrown) 
	         {
	            try 
	            {
	              console.log("Fail Status : " + jqXHR.status);
	              console.log("code : "        + jqXHR.responseJSON.code);
	              console.log("message : "     + jqXHR.responseJSON.message);
	              console.log("detailMessage : "  + jqXHR.responseJSON.detailMessage);
	            } 
	            catch (e) 
	            {
	              console.log(e);
	            }
	         
	            Common.alert("Fail : " + jqXHR.responseJSON.message);
	        }); 
  
}

function insertStatusCatalogDetail()
{
  //getItemsByCheckedField();
  
  if ($("#selCategoryId").val().length < 1 )
  {
    Common.alert("<spring:message code='sys.msg.first.Select' arguments='Category ID' htmlEscape='false'/>");
    return;
  }
  
  var formDataParameters = 
      {
        gridDataSet   : GridCommon.getEditData(statusCodeGridID),
        commStatusVO  : {
                         catalogId : MainForm.selCategoryId.value,
                         catalogNm : MainForm.selStusCtgryName.value
                        }
      };
  
  Common.ajax("POST", "/status/insertStatusCatalogDetail.do"
         , formDataParameters
         , function(result) 
           {
            fnSelectCategoryListAjax() ;     
            console.log("saveCategoryDetail 성공.");
            console.log("dataSuccess : " + result.data);
	          Common.alert(result.data  + "<spring:message code='sys.msg.savedCnt'/>"); 
           } 

         , function(jqXHR, textStatus, errorThrown) 
           {
              try 
              {
                console.log("Fail Status : " + jqXHR.status);
                console.log("code : "        + jqXHR.responseJSON.code);
                console.log("message : "     + jqXHR.responseJSON.message);
                console.log("detailMessage : "  + jqXHR.responseJSON.detailMessage);
              } 
              catch (e) 
              {
                console.log(e);
              }
           
              Common.alert("Fail : " + jqXHR.responseJSON.message);
          }); 
  
}

function fnUpdDisabled()
{
  //getItemsByCheckedField();
  
  if ($("#selCategoryId").val().length < 1 )
  {
    Common.alert("<spring:message code='sys.msg.first.Select' arguments='Category ID' htmlEscape='false'/>");
    return;
  }
  
  var formDataCategoryYN = 
	    {
		    gridDataSet   : GridCommon.getEditData(detailGridID),   // VO에 쓰일 변수명, 일치시킨다.
		    commStatusVO  : {
                         catalogId : MainForm.selCategoryId.value,  // 필드명(key)과 매핑시킨다
                         catalogNm : MainForm.selStusCtgryName.value
                        }
      };
  
  Common.ajax("POST", "/status/UpdCategoryCdYN.do"
	       , formDataCategoryYN
	       , function(result) 
	         {
	          fnSelectCategoryListAjax() ;     
	          console.log("UpdSuccess : " + result.data);
	          Common.alert(result.data  + "<spring:message code='sys.msg.savedCnt'/>");     
	         } 

	       , function(jqXHR, textStatus, errorThrown) 
	         {
	            try 
	            {
	              console.log("Fail Status : " + jqXHR.status);
	              console.log("code : "        + jqXHR.responseJSON.code);
	              console.log("message : "     + jqXHR.responseJSON.message);
	              console.log("detailMessage : "  + jqXHR.responseJSON.detailMessage);
	            } 
	            catch (e) 
	            {
	              console.log(e);
	            }
	         
	            Common.alert("Fail : " + jqXHR.responseJSON.message);
	        }); 
  
}
</script>

<section id="content"><!-- content start -->
<ul class="path">
  <li><img src="${pageContext.request.contextPath}/resources/images/common/path_home.gif" alt="Home" /></li>
  <li>Sales</li>
  <li>Order</li>
  <li>Order</li>
</ul>

<aside class="title_line"><!-- title_line start -->
<p class="fav"><a href="#" class="click_add_on">My menu</a></p>
<h2>Statsus Code Management</h2>
<ul class="right_btns">
  <li><p class="btn_blue"><a onclick="fnSelectCategoryListAjax();"><span class="search"></span>Search</a></p></li>
</ul>
</aside><!-- title_line end -->
<form id="MainForm" method="get" action="">

<input type ="hidden" id="selCategoryId" name="selCategoryId" value=""/>
<input type ="hidden" id="selStusCtgryName" name="selStusCtgryName" value=""/>

<table class="type1"><!-- table start -->
<caption>table</caption>
<colgroup>
  <col style="width:150px" />
  <col style="width:*" />
  <col style="width:150px" />
  <col style="width:*" />
  <col style="width:150px" />
  <col style="width:*" />
</colgroup>
<tbody>
<tr>
  <th scope="row">Category ID</th>
  <td>
  <input type="text" title="" id="paramCategoryId" name="paramCategoryId"  placeholder="Category ID" class="w100p" />
  </td>
  <th scope="row">Category Name</th>
  <td>
  <input type="text" title="" id="paramCategoryNM" name="paramCategoryNM" placeholder="Category Name" class="w100p" />
  </td>
  <th scope="row">Creator ID</th>
  <td>
  <input type="text" title="" id="paramCreateID" name="paramCreateID" placeholder="Creator ID" class="w100p" />
  </td>
</tr>
</tbody>
</table><!-- table end -->

<aside class="title_line"><!-- title_line start -->
<h3>Status Category</h3>
<ul class="right_btns">
  <li><p class="btn_grid"><a onclick="addRowCategory();">ADD</a></p></li>
  <li><p class="btn_grid"><a onclick="saveCategory();">SAVE</a></p></li>
</ul>
</aside><!-- title_line end -->

<section class="search_result"><!-- search_result start -->

<article class="grid_wrap"><!-- grid_wrap start -->
<!-- 그리드 영역1 -->
 <div id="grid_wrap"></div>
</article><!-- grid_wrap end -->

</section><!-- search_result end -->

<section class="search_result"><!-- search_result start -->

<div class="divine_auto type2"><!-- divine_auto start -->

<div style="width:45%"><!-- 50% start -->

<aside class="title_line"><!-- title_line start -->
<h3>Status Code</h3>
</aside><!-- title_line end -->

<div class="border_box" style="height:330px;"><!-- border_box start -->


<ul class="right_btns pt0">
  <li><p class="btn_grid"><a onclick="addRowStatusCode();">ADD</a></p></li>
  <li><p class="btn_grid"><a onclick="saveStatusCode();">SAVE</a></p></li>
</ul>

<article class="grid_wrap"><!-- grid_wrap start -->
<!-- 그리드 영역2 -->
 <div id="codeIdGrid"></div>
</article><!-- grid_wrap end -->

<ul class="btns right-type">
  <li><a onclick="insertStatusCatalogDetail();"><img src="${pageContext.request.contextPath}/resources/images/common/btn_right2.gif" alt="right" /></a></li>
</ul>

</div><!-- border_box end -->

</div><!-- 50% end -->

<div style="width:55%"><!-- 50% start -->

<aside class="title_line"><!-- title_line start -->
<h3>Status Category Code Management</h3>
</aside><!-- title_line end -->

<div class="border_box" style="height:330px;"><!-- border_box start -->

<ul class="right_btns pt0">
  <li><p class="btn_grid">&nbsp;</p></li>
  <li><p class="btn_grid"><a onclick="fnUpdDisabled();">SAVE</a></p></li>
</ul>

<article class="grid_wrap"><!-- grid_wrap start -->
<!-- 그리드 영역3 -->
 <div id="detailGrid"></div>
</article><!-- grid_wrap end -->

</div><!-- border_box end -->

</div><!-- 50% end -->


</div><!-- divine_auto end -->

</section><!-- search_result end -->

</form>
</section><!-- content end -->