<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>

<script type="text/javaScript">

var gSelRowIdx = 0;

var statusCategoryLayout = 
    [      
        {    
            dataField : "stusCtgryId",
            headerText : "CATEGORY ID",
            width : 200
        }, {
            dataField : "stusCtgryName",
            headerText : "CATEGORY NAME",
            width : 250
        }, {
            dataField : "stusCtgryDesc",
            headerText : "CATEGORY DESCRIPTION",
            width : 250
        }, {
            dataField : "crtUserId",
            headerText : "CREATE USER ID",
            width : 200
           ,editable : false
        }, {
            dataField : "updUserId",
            headerText : "LAST UPDATE USER ID",
            width : 200
           ,editable : false            
        }, {
            dataField : "updDt",
            headerText : "LAST UPDATE",
            dataType : "date",
            formatString : "dd-mmm-yyyy HH:MM:ss",
            width : 200
           ,editable : false
        }
    ];


var detailColumnLayout = 
    [  
        {
            dataField : "stusCodeId",
            headerText : "CODE ID",
            width : 200
           ,editable : false
        }, {
            dataField : "codeName",
            headerText : "CODE NAME",
            width : 200
           ,editable : false
        }, {
            dataField : "codeDisab",
            headerText : "DISABLED",
            width : 150,
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
          width : 50,
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
            headerText : "CODE ID",
            width : 100
      },{
          dataField : "codeName",
          headerText : "CODE NAME",
          width : 200
      },{
          dataField : "code",
          headerText : "CODE",
          width : 70
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

	  var options = {
                  usePaging : true,
                  useGroupingPanel : false
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
        
        console.log("CellClick rowIndex : " + event.rowIndex + ", columnIndex : " + event.columnIndex + " clickedCategoryId: " + $("#selCategoryId").val() +" / "+ $("#paramCategoryId").val());        
    });

 // 셀 더블클릭 이벤트 바인딩
    AUIGrid.bind(myGridID, "cellDoubleClick", function(event) 
    {
        console.log("DobleClick ( " + event.rowIndex + ", " + event.columnIndex + ") :  " + " value: " + event.value );

        if (AUIGrid.isAddedById(myGridID,AUIGrid.getCellValue(myGridID, event.rowIndex, 0)) == true
            || String(event.value).length < 1)
        {
                alert("Status Category ID Confirm!!");
                return false;
        } 

        fnGetCategoryCd(myGridID, event.rowIndex);
    });    

/***********************************************[ DETAIL GRID] ************************************************/

    var dtailOptions = 
        {
            usePaging : false,
            // 체크박스 표시 설정
           // showRowCheckColumn : true,
            // 전체 체크박스 표시 설정
            //showRowAllCheckBox : true,          
            //showEditedCellMarker : true,
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
  Common.ajax("GET", "/common/selectStatusCategoryList.do"
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
   Common.ajax("GET", "/common/selectStatusCategoryCdList.do"
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
  Common.ajax("GET", "/common/selectStatusCdIdList.do"
       , $("#MainForm").serialize()
       , function(result) 
       {
          console.log("성공 data : " + result);
          AUIGrid.setGridData(statusCodeGridID, result);
       });
}

function saveStatusCode()
{
  if ($("#selCategoryId").val().length < 1 )
	{
	  Common.alert(' Please Select the Category ID.');
	  return;
	}
	
  Common.ajax("POST", "/common/saveStatusCode.do"
	         , GridCommon.getEditData(statusCodeGridID)
	         , function(result) 
	           {
                fnSelectCategoryListAjax() ; 
		            console.log("saveCategory 성공.");
		            console.log("dataSuccess : " + result.data);
		            Common.alert("[ Success: " + result.data + " Count ]");    
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
	           
	            alert("Fail : " + jqXHR.responseJSON.message);
	          }); 
  
}

function saveCategory()
{
  Common.ajax("POST", "/common/saveStatusCategory.do"
	       , GridCommon.getEditData(myGridID)
	       , function(result) 
	         {
            fnSelectCategoryListAjax() ;
	          console.log("saveCategory 성공.");
	          console.log("dataSuccess : " + result.data);
	          Common.alert("[ Success: " + result.data + " Count ]");    
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
	         
	          alert("Fail : " + jqXHR.responseJSON.message);
	        }); 
  
}

function insertStatusCatalogDetail()
{
  //getItemsByCheckedField();
  
    if ($("#selCategoryId").val().length < 1 )
  {
    Common.alert(' Please Select the Category ID 1.');
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
  
  Common.ajax("POST", "/common/insertStatusCatalogDetail.do"
         , formDataParameters
         , function(result) 
           {
            fnSelectCategoryListAjax() ;     
            console.log("saveCategoryDetail 성공.");
            console.log("dataSuccess : " + result.data);
	          Common.alert("[ Success: " + result.data + " Count ]");     
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
           
            alert("Fail : " + jqXHR.responseJSON.message);
          }); 
  
}

function fnUpdDisabled()
{
  //getItemsByCheckedField();
  
  if ($("#selCategoryId").val().length < 1 )
  {
    Common.alert(' Please Select the Category ID.');
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
  
  Common.ajax("POST", "/common/UpdCategoryCdYN.do"
	       , formDataCategoryYN
	       , function(result) 
	         {
	          fnSelectCategoryListAjax() ;     
	          console.log("UpdSuccess : " + result.data);
	          Common.alert("[ Success: " + result.data + " Count ]");     
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
	         
	          alert("Fail : " + jqXHR.responseJSON.message);
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

<div style="width:40%"><!-- 50% start -->

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

<div style="width:60%"><!-- 50% start -->

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
<aside class="bottom_msg_box"><!-- bottom_msg_box start -->
<p>Information Message Area</p>
</aside><!-- bottom_msg_box end -->
    
</section><!-- container end -->
<hr />

</div><!-- wrap end -->

