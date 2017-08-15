<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>

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

</style>

<script type="text/javaScript">
var gSelMainRowIdx = 0;
var StatusCdList = new Array();

$(function() 
{
  //getStatusComboListAjax();
});

var MainColumnLayout = 
    [      
        {    
            dataField : "authCode",
            headerText : "<spring:message code='sys.grid.headerTxt' arguments='Code' htmlEscape='false'/>",
            width : 120
        }, {
            dataField : "authName", 
            headerText : "<spring:message code='sys.grid.headerTxt' arguments='Name' htmlEscape='false'/>",  
            width : 400
        }, {
            dataField : "roleId",
            headerText : "<spring:message code='sys.grid.headerTxt' arguments='Role' htmlEscape='false'/>", 
            width : 150,
            editable : false,
            style : "aui-grid-left-column",
             renderer : {
                type : "IconRenderer",
                iconWidth : 13, // icon 가로 사이즈, 지정하지 않으면 24로 기본값 적용됨
                iconHeight : 13,
                iconPosition : "aisleRight",
                iconFunction : function(rowIndex, columnIndex, value, item) 
                {
                  if (item.roleLvl == null)  // && value ==  null
                  {
                      return null;
                  }
                  else
                  {
                    return "${pageContext.request.contextPath}/resources/images/common/normal_search.gif";
                  }

                } ,// end of iconFunction                
          
                onclick : function(rowIndex, columnIndex, value, item) 
                         {
                            console.log("onclick: ( " + rowIndex + ", " + columnIndex + " ) " + item.authLvl + " POPUP 클릭");
                            if (item.authLvl == "1")
                            {
                              //Common.alert("Can't Select UpperAuth In 'Lvl 1.' ");
                              Common.alert("<spring:message code='sys.msg.cannot' arguments='Select UpperAuth ; Lvl 1.' htmlEscape='false' argumentSeparator=';'/>");
                              return false;
                            }
                            
                            gSelMainRowIdx = rowIndex;
                            fnSearchRolePopUp(); 
                         }
                } // IconRenderer
        } ,{
            dataField : "roleLvl", 
            headerText : "<spring:message code='sys.grid.headerTxt' arguments='Lvl' htmlEscape='false'/>",
            width : 80
        }, {
            dataField : "roleId1",
            headerText : "<spring:message code='sys.grid.headerTxt' arguments='Role_1' htmlEscape='false'/>",
            width : 200
        }, {
            dataField : "roleId2",
            headerText : "<spring:message code='sys.grid.headerTxt' arguments='Role_2' htmlEscape='false'/>",
            width : 200
        }, {
            dataField : "roleId3",
            headerText : "<spring:message code='sys.grid.headerTxt' arguments='Role_3' htmlEscape='false'/>",
            width : 200
        },{
            dataField : "hidden",
            headerText : "",
            width : 0
          } 
    ];

function getStatusComboListAjax(callBack) 
{
    //Common.ajaxSync("GET", "/common/selectCodeList.do"
    Common.ajaxSync("GET", "/status/selectStatusCategoryCdList.do"
                 , $("#MainForm").serialize()
                 , function(result) 
                 {
                    for (var i = 0; i < result.length; i++) 
                    {
                      var list = new Object();
                          list.id = result[i].stusCodeId;
                          list.value = result[i].codeName ;
                          StatusCdList.push(list);
                    }

                    //if you need callBack Function , you can use that function
                    if (callBack) {
                      callBack(StatusCdList);
                    }
                    
                  });
    return StatusCdList;
  }

//AUIGrid 메소드
//컬럼 선택시 상세정보 세팅.
function fnSetSelectedColumn(selGrdidID, rowIdx)  
{     
 $("#selAuthId").val(AUIGrid.getCellValue(selGrdidID, rowIdx, "authCode"));
  
 console.log("selAuthId: "+ $("#selAuthId").val() + " authName: " + AUIGrid.getCellValue(selGrdidID, rowIdx, "authName") );                
}

function auiCellEditignHandler(event) 
{
  if(event.type == "cellEditBegin") 
  {
      console.log("에디팅 시작(cellEditBegin) : (rowIdx: " + event.rowIndex + ",columnIdx: " + event.columnIndex + " ) " + event.headerText + ", value : " + event.value);
      var authSeq = AUIGrid.getCellValue(myGridID, event.rowIndex, "authCode");
      
      if (AUIGrid.isAddedById(myGridID,authSeq) == false && authSeq.indexOf("Input authCode") == -1 && event.columnIndex == 0 )// edit
      {
        return false;  // edit모드일 때만 authCode를 수정할수 있다.
      }
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

//MstGrid 행 추가, 삽입
function fnAddRow() 
{
  var item = new Object();

      item.authCode ="Input authCode";
      item.authName ="The delimiter for the level is '>' ";
      item.roleId   ="";
      item.roleLvl  ="";
      item.roleId1  ="";
      item.roleId2  ="";
      item.roleId3  ="";
      // parameter
      // item : 삽입하고자 하는 아이템 Object 또는 배열(배열인 경우 다수가 삽입됨)
      // rowPos : rowIndex 인 경우 해당 index 에 삽입, first : 최상단, last : 최하단, selectionUp : 선택된 곳 위, selectionDown : 선택된 곳 아래
      AUIGrid.addRow(myGridID, item, "first");
}

//Make Use_yn ComboList, tooltip
function getAuthLevel()
{     
  var list =  ["2", "3", "4"];   
  return list;
}

//행 삭제 이벤트 핸들러
function auiRemoveRowHandler(event) 
{
  console.log (event.type + " 이벤트 :  " + ", 삭제된 행 개수 : " + event.items.length + ", softRemoveRowMode : " + event.softRemoveRowMode);
  //$("#delCancel").show();
}

//행 삭제 이벤트 핸들러
function auiRemoveRowHandlerDetail(event) 
{
  console.log (event.type + " 이벤트상세 :  " + ", 삭제된 행 개수 : " + event.items.length + ", softRemoveRowMode : " + event.softRemoveRowMode);
}

//행 삭제 메소드
function fnRemoveRow() 
{
  console.log("fnRemoveRowMst: " + gSelMainRowIdx);    
  AUIGrid.removeRow(myGridID,"selectedIndex");
}

function fnSearchRolePopUp() 
{
   var popUpObj = Common.popupDiv("/authorization/searchRolePop.do"
       , $("#MainForm").serializeJSON()
       , null
       , "true"  // true면 close버튼 클릭시 화면 close
       );
        
}

function fnSetParamAuthCd(myGridID, rowIndex)
{
  $("#authCode").val(AUIGrid.getCellValue(myGridID, rowIndex, "authCode"));
  $("#authName").val(AUIGrid.getCellValue(myGridID, rowIndex, "authName"));
   
  console.log("authCode: "+ $("#authCode").val() + "authName: "+ $("#authName").val() );     
}

function fnSelectAuthListAjax()
{
   Common.ajax("GET", "/authorization/selectAuthList.do"
           , $("#MainForm").serialize()
           , function(result) 
           {
              console.log("성공 data : " + result);
              AUIGrid.setGridData(myGridID, result);
              if(result != null && result.length > 0)
              {
                //fnSetSelectedColumn(myGridID, 0);
              }
           });
}

function fnSaveAuthCd() 
{
  if (fnValidationCheck() == false)
  {
    return false;
  }
  
  Common.ajax("POST", "/authorization/saveAuth.do"
        , GridCommon.getEditData(myGridID)
        , function(result) 
          {
            Common.alert(result.data  + "<spring:message code='sys.msg.savedCnt'/>");
            fnSelectAuthListAjax() ;
            
            console.log("성공." + JSON.stringify(result));
            console.log("data : " + result.data);
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

//삭제해서 마크 된(줄이 그어진) 행을 복원 합니다.(삭제 취소)
function removeAllCancel() 
{
  $("#delCancel").hide();
  
  AUIGrid.restoreSoftRows(myGridID, "all"); 
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
      var authCode  = addList[i].authCode;
      var authName  = addList[i].authName;
      var roleId    = addList[i].roleId;
      var roleLvl   = addList[i].roleLvl;
      var roleId1   = addList[i].roleId1;
      var roleId2   = addList[i].roleId2;
      var roleId3   = addList[i].roleId3;
      
      if (authCode == "" || authCode.length == 0) 
      {
        result = false;
        // {0} is required.
        Common.alert("<spring:message code='sys.msg.necessary' arguments='Auth Code' htmlEscape='false'/>");
        break;
      }
      
      if (authName == "" || authName.length == 0) 
      {
        result = false;
        // {0} is required.
        Common.alert("<spring:message code='sys.msg.necessary' arguments='Auth authName' htmlEscape='false'/>");
        break;
      }

      if (authName.indexOf("delimiter") > 0 ) 
      {
        result = false;
        // {0} is required.
        Common.alert("<spring:message code='sys.msg.necessary' arguments='Auth authName' htmlEscape='false'/>");
        break;
      }
      
    }  // addlist

     
    for (var i = 0; i < udtList.length; i++) 
    {
        var authCode  = udtList[i].authCode;
        var authName  = udtList[i].authName;
        var roleId    = udtList[i].roleId;
        var roleLvl   = udtList[i].roleLvl;
        var roleId1   = udtList[i].roleId1;
        var roleId2   = udtList[i].roleId2;
        var roleId3   = udtList[i].roleId3;

        if (authCode == "" || authCode.length == 0) 
        {
          result = false;
          Common.alert("<spring:message code='sys.msg.necessary' arguments='Auth Code' htmlEscape='false'/>");
          break;
        }
        
    }// udtlist

    for (var i = 0; i < delList.length; i++) 
    {
        var authCode  = delList[i].authCode;
        
        if (authCode == "" || authCode.length == 0 ) 
        {
          result = false;
          Common.alert("<spring:message code='sys.msg.necessary' arguments='Auth Code' htmlEscape='false'/>");
          break;
        }
        
     } //delete
    
    return result;
  }

//trim
String.prototype.fnTrim = function() 
{
    return this.replace(/(^\s*)|(\s*$)/gi, "");
}


/****************************  Form Ready ******************************************/

var myGridID;

$(document).ready(function()
{
    $("#authCode").focus();
    
    $("#authCode").keydown(function(key) 
    {
       if (key.keyCode == 13) 
       {
         fnSelectAuthListAjax();
       }

    });

    $("#authCode").bind("keyup", function() 
    {
      $(this).val($(this).val().toUpperCase());
    });
    
    $("#authName").keydown(function(key) 
    {
       if (key.keyCode == 13) 
       {
         fnSelectAuthListAjax();
       }
    });

    $("#authName").bind("keyup", function() 
    {
      $(this).val($(this).val().toUpperCase());
    });

/***************************************************[ Main GRID] ***************************************************/    

    var options = {
                  usePaging : true,
                  useGroupingPanel : false,
                  selectionMode : "multipleRows",
                  // 셀머지된 경우, 행 선택자(selectionMode : singleRow, multipleRows) 로 지정했을 때 병합 셀도 행 선택자에 의해 선택되도록 할지 여부
                  rowSelectionWithMerge : true,
                  editable : true,
                  // 셀, 행 수정 후 원본으로 복구 시키는 기능 사용 가능 여부 (기본값:true)
                  enableRestore : true,
                };
    
    // masterGrid 그리드를 생성합니다.
    myGridID = GridCommon.createAUIGrid("grid_wrap", MainColumnLayout,"", options);
    // AUIGrid 그리드를 생성합니다.
    
    // 푸터 객체 세팅
    
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
        gSelMainRowIdx = event.rowIndex;
        
        console.log("CellClick rowIndex : " + event.rowIndex + ", columnIndex : " + event.columnIndex + " clickedAuthId: " + $("#selAuthId").val() );        
    });

 // 셀 더블클릭 이벤트 바인딩
    AUIGrid.bind(myGridID, "cellDoubleClick", function(event) 
    {
        console.log("DobleClick ( " + event.rowIndex + ", " + event.columnIndex + ") :  " + " value: " + event.value );
    });    


    $("#delCancel").hide();
    
});   //$(document).ready


</script>
		
<section id="content"><!-- content start -->
<ul class="path">
  <li><img src="${pageContext.request.contextPath}/resources/images/common/path_home.gif" alt="Home" /></li>
  <li>Sales</li>
  <li>Order list</li>
</ul>

<aside class="title_line"><!-- title_line start -->
<p class="fav"><a href="#" class="click_add_on">My menu</a></p>
<h2>Role Authorization Mapping</h2>
<ul class="right_btns">
  <li><p class="btn_blue"><a href="#"><span class="search"></span>Search</a></p></li>
  <li><p class="btn_blue"><a href="#">Save</a></p></li>
</ul>
</aside><!-- title_line end -->


<section class="search_table"><!-- search_table start -->
<form action="#" method="post">

<table class="type1"><!-- table start -->
<caption>table</caption>
<colgroup>
  <col style="width:110px" />
  <col style="width:*" />
  <col style="width:110px" />
  <col style="width:*" />
</colgroup>
<tbody>
<tr>
  <th scope="row">Role</th>
  <td>
  <input type="text" title="" placeholder="" class="" />
  </td>
  <th scope="row"></th>
  <td>
  <input type="text" title="" placeholder="" class="" />
  </td>
</tr>
</tbody>
</table><!-- table end -->

<aside class="link_btns_wrap"><!-- link_btns_wrap start -->
<p class="show_btn"><%-- <a href="#"><img src="${pageContext.request.contextPath}/resources/images/common/btn_link.gif" alt="link show" /></a> --%></p>
<dl class="link_list">
  <dt>Link</dt>
  <dd>
  <ul class="btns">
    <li><p class="link_btn"><a href="#">menu1</a></p></li>
    <li><p class="link_btn"><a href="#">menu2</a></p></li>
    <li><p class="link_btn"><a href="#">menu3</a></p></li>
    <li><p class="link_btn"><a href="#">menu4</a></p></li>
    <li><p class="link_btn"><a href="#">Search Payment</a></p></li>
    <li><p class="link_btn"><a href="#">menu6</a></p></li>
    <li><p class="link_btn"><a href="#">menu7</a></p></li>
    <li><p class="link_btn"><a href="#">menu8</a></p></li>
  </ul>
  <ul class="btns">
    <li><p class="link_btn type2"><a href="#">menu1</a></p></li>
    <li><p class="link_btn type2"><a href="#">Search Payment</a></p></li>
    <li><p class="link_btn type2"><a href="#">menu3</a></p></li>
    <li><p class="link_btn type2"><a href="#">menu4</a></p></li>
    <li><p class="link_btn type2"><a href="#">Search Payment</a></p></li>
    <li><p class="link_btn type2"><a href="#">menu6</a></p></li>
    <li><p class="link_btn type2"><a href="#">menu7</a></p></li>
    <li><p class="link_btn type2"><a href="#">menu8</a></p></li>
  </ul>
  <p class="hide_btn"><a href="#"><img src="${pageContext.request.contextPath}/resources/images/common/btn_link_close.gif" alt="hide" /></a></p>
  </dd>
</dl>
</aside><!-- link_btns_wrap end -->

</form>
</section><!-- search_table end -->

<section class="search_result"><!-- search_result start -->

<div class="divine_auto"><!-- divine_auto start -->

<div style="width:60%;">

<div class="border_box" style="height:450px;"><!-- border_box start -->

<aside class="title_line"><!-- title_line start -->
<h3 class="pt0">Role Auth Mapping</h3>
</aside><!-- title_line end -->

<article class="grid_wrap"><!-- grid_wrap start -->
그리드 영역
</article><!-- grid_wrap end -->

</div><!-- border_box end -->

</div>

<div style="width:40%;">

<div class="border_box" style="height:450px;"><!-- border_box start -->

<aside class="title_line"><!-- title_line start -->
<h3 class="pt0">Auth Management</h3>
<ul class="right_opt">
  <li><p class="btn_grid"><a href="#">Add</a></p></li>
  <li><p class="btn_grid"><a href="#">Del</a></p></li>
</ul>
</aside><!-- title_line end -->

<article class="grid_wrap"><!-- grid_wrap start -->
그리드 영역
</article><!-- grid_wrap end -->

</div><!-- border_box end -->

</div>

</div><!-- divine_auto end -->


</section><!-- search_result end -->

</section><!-- content end -->

<aside class="bottom_msg_box"><!-- bottom_msg_box start -->
<p>Information Message Area</p>
</aside><!-- bottom_msg_box end -->
    
</section><!-- container end -->
<hr />

</div><!-- wrap end -->
</body>
</html>