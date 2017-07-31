<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>

<script type="text/javaScript">
//

var mstColumnLayout = 
    [ //{accId=1, accCode=1000/000, accDesc=FIXED ASSTES AT COST, accCrtUserId=349, accUpdUserId=0, accStusId=1, isPayCash=0, isPayOnline=0, isPayChq=0, isPayCrc=0, statusCode=ACT,statusName=Active, accIsMfg=0, accPayTypeId=0, accType=-2147483647, accAddAreaId=0, accAddCntyId=0, c14=01-1월 -1900 00:00:00, userName47=SYSDBA, accAddPostCodeId=0, postCodeId=0, accAddStateId=0, c23=01-1월 -1900 00:00:00},
        {    
            dataField : "accId",
            headerText : "ID",
            width : 120
           ,editable : false
        }, {
            dataField : "accCode",
            headerText : "CODE",
            width : 200
           ,editable : false
        }, {
            dataField : "accDesc",
            headerText : "DESCRIPTION",
            width : 170
            ,editable : false
        }, {
            dataField : "sapAccCode",
            headerText : "SAP CODE",
            width : 140
            ,editable : false
        }, {
            dataField : "statusCode",
            headerText : "STATUS",
            width : 140
            ,editable : false
        }, {
            dataField : "isPayCash",
            headerText : "CASH",
            width : 140
          , renderer : 
            {
                type : "CheckBoxEditRenderer",
                showLabel : false, // 참, 거짓 텍스트 출력여부( 기본값 false )
                editable : false, // 체크박스 편집 활성화 여부(기본값 : false)
                checkValue : true, // true, false 인 경우가 기본
                unCheckValue : false
                
                // 체크박스 Visible 함수
               , visibleFunction : function(rowIndex, columnIndex, value, isChecked, item, dataField) 
                 {
                   if(item.isPayCash == true)  
                   {
                    return true; // checkbox visible
                   }

                   return true;
                 }
  
            }
        ,editable : false
                      
        }, {
            dataField : "isPayChq",
            headerText : "CHEQUE",
            width : 140
          , renderer : 
            {
                type : "CheckBoxEditRenderer",
                showLabel : false, // 참, 거짓 텍스트 출력여부( 기본값 false )
                editable : false, // 체크박스 편집 활성화 여부(기본값 : false)
                checkValue : true, // true, false 인 경우가 기본
                unCheckValue : false
                // 체크박스 Visible 함수
               , visibleFunction : function(rowIndex, columnIndex, value, isChecked, item, dataField) 
                 {
                   if(item.isPayChq == true)  
                   {
                    return true; // checkbox visible
                   }

                   return true;
                 }
            }  //renderer
        ,editable : false
        
        }, {
            dataField : "isPayOnline",
            headerText : "ONLINE",
            width : 140
            , renderer : 
            {
                type : "CheckBoxEditRenderer",
                showLabel : false, // 참, 거짓 텍스트 출력여부( 기본값 false )
                editable : false, // 체크박스 편집 활성화 여부(기본값 : false)
                checkValue : true, // true, false 인 경우가 기본
                unCheckValue : false
                // 체크박스 Visible 함수
               , visibleFunction : function(rowIndex, columnIndex, value, isChecked, item, dataField) 
                 {
                   if(item.isPayOnline == true)  
                   {
                    return true; // checkbox visible
                   }

                   return true;
                 }
            }  //renderer
        ,editable : false
                    
        }, {
            dataField : "isPayCrc",
            headerText : "CREDIT CARD",
            width : 140
            , renderer : 
            {
                type : "CheckBoxEditRenderer",
                showLabel : false, // 참, 거짓 텍스트 출력여부( 기본값 false )
                editable : false, // 체크박스 편집 활성화 여부(기본값 : false)
                checkValue : true, // true, false 인 경우가 기본
                unCheckValue : false
                // 체크박스 Visible 함수
               , visibleFunction : function(rowIndex, columnIndex, value, isChecked, item, dataField) 
                 {
                   if(item.isPayCrc == true)  
                   {
                    return true; // checkbox visible
                   }

                   return true;
                 }
            }  //renderer   
        ,editable : false
                 
       },{
           dataField : "accAddCntyId",
           headerText : "CNTY ID",
           width : 50,
           visible : false
       },{
           dataField : "accAddStateId",
           headerText : "STATUS ID",
           width : 50,
           visible : false
       },{
           dataField : "accAddAreaId",
           headerText : "AREA ID",
           width : 50,
           visible : false
       },{
           dataField : "accAddPostCodeId",
           headerText : "POST CODE",
           width : 50,
           visible : false
       }
       
    ];

//ajax list 조회.

function fnGetAccountCdListAjax() 
{        
	  Common.ajax("GET", "/common/selectAccountCodeList.do"
       , $("#MainForm").serialize()
       , function(result) 
       {  
          console.log("성공." + JSON.stringify(result));
          AUIGrid.setGridData(myGridID, result);
         
          if(result != null && result.length > 0)
          {
       	    fnSetDetail(myGridID,0);
          }  
       }); 
}

// 그리드 이벤트 바인딩
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

//행 삭제 이벤트 핸들러
function auiRemoveRowHandler(event) 
{
    console.log (event.type + " 이벤트 :  " + ", 삭제된 행 개수 : " + event.items.length + ", softRemoveRowMode : " + event.softRemoveRowMode);
}

// 행 삭제 메소드
function removeRow() 
{
    console.log("removeRowMst: " + gSelRowIdx);    
    AUIGrid.removeRow(myGridID,gSelRowIdx);
}

function editPopUp() 
{
	  if ($("#paramAccCode").val().length < 1)
	  {
		  alert( "One Item Choose!" );
		  return false;
	  } 

	  $("#parmAddEditFlag").val("EDIT");

    var popUpObj = Common.popupDiv("/common/accountCodeEditPop.do"
    	    , $("#MainForm").serializeJSON()
          , null
          , "false"
    	    );

    return ;
}

function addPopUp() 
{
	  $("#parmAddEditFlag").val("ADD");

    var popUpObj = Common.popupDiv("/common/accountCodeAddPop.do"
            , $("#MainForm").serializeJSON()
            , null
            , "false"
            );

    return ;
}


//컬럼 선택시 상세정보 세팅.
function fnSetDetail(selGrdidID, rowIdx)  //cdMstId
{     
   $("#paramAccCodeId").val(AUIGrid.getCellValue(selGrdidID, rowIdx, "accId"));  
   $("#paramAccCode").val(AUIGrid.getCellValue(selGrdidID, rowIdx, "accCode"));  
   $("#paramAccDesc").val(AUIGrid.getCellValue(selGrdidID, rowIdx, "accDesc"));  
   $("#paramSapAccCode").val(AUIGrid.getCellValue(selGrdidID, rowIdx, "sapAccCode"));  
   $("#parmIsPayCash").val(AUIGrid.getCellValue(selGrdidID, rowIdx, "isPayCash"));  
   $("#parmIsPayChq").val(AUIGrid.getCellValue(selGrdidID, rowIdx, "isPayChq"));  
   $("#parmIsPayOnline").val(AUIGrid.getCellValue(selGrdidID, rowIdx, "isPayOnline"));  
   $("#parmIsPayCrc").val(AUIGrid.getCellValue(selGrdidID, rowIdx, "isPayCrc"));  
   $("#parmAddCntyId").val(AUIGrid.getCellValue(selGrdidID, rowIdx, "accAddCntyId"));  
   $("#paramAddStateId").val(AUIGrid.getCellValue(selGrdidID, rowIdx, "accAddStateId"));  
   $("#paramAddAreaId").val(AUIGrid.getCellValue(selGrdidID, rowIdx, "accAddAreaId"));  
   $("#pramAddPostCodeId").val(AUIGrid.getCellValue(selGrdidID, rowIdx, "accAddPostCodeId"));  
   $("#accId").val(AUIGrid.getCellValue(selGrdidID, rowIdx, "accId"));

   console.log(" paramAccCodeId:"+ $("#paramAccCodeId").val() +" paramAccCode:  "+ $("#paramAccCode").val() + " paramAccDesc: " + $("#paramAccDesc").val() + " paramSapAccCode: " + $("#paramSapAccCode").val() 
		           + " parmIsPayCash: "+ $("#parmIsPayCash").val() + " parmIsPayChq: " + $("#parmIsPayChq").val() + " parmIsPayOnline: " + $("#parmIsPayOnline").val()
		           + " parmIsPayCrc:  "+ $("#parmIsPayCrc").val() + " accAddCntyId: " + $("#parmAddCntyId").val() + " paramAddStateId: " + $("#paramAddStateId").val()
		           + " paramAddAreaId:  "+ $("#paramAddAreaId").val() + " pramAddPostCodeId: " + $("#pramAddPostCodeId").val() 
		          );                
}

//AUIGrid 생성 후 반환 ID
var myGridID;

$(document).ready(function()
{
  var options = {
                  usePaging : true,
                  useGroupingPanel : false,
                  //showRowCheckColumn : true
                };
    
    // masterGrid 그리드를 생성합니다.
    myGridID = GridCommon.createAUIGrid("MasterGrid", mstColumnLayout,"accId", options);
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
        console.log("CellClick rowIndex : " + event.rowIndex + ", columnIndex : " + event.columnIndex + " clicked");
        
        gSelRowIdx = event.rowIndex;
        $("#paramAccCode").val("");
        $("#accId").val("");
    });

 // 셀 더블클릭 이벤트 바인딩
    AUIGrid.bind(myGridID, "cellDoubleClick", function(event) 
    {
        console.log("DobleClick ( " + event.rowIndex + ", " + event.columnIndex + ") :  " + " value: " + event.value );

        if (AUIGrid.isAddedById(myGridID,AUIGrid.getCellValue(myGridID, event.rowIndex, 0)) == true)
        {
            return false;
        }
        else
        {
           var selectedItem = AUIGrid.getSelectedIndex(myGridID);
           console.log("selectedItem: " + event.value);  // rowIndex.. data exists
           console.log(">> " + AUIGrid.getCellValue(myGridID, event.rowIndex, "accCode"));
           fnSetDetail(myGridID,event.rowIndex);
        	 return true;
        } 
    });
        

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
<h2>Account Code Management</h2>
<ul class="right_btns">
	<li><p class="btn_blue"><a onclick="fnGetAccountCdListAjax();"><span class="search"></span>Search</a></p></li>
</ul>
</aside><!-- title_line end -->


<section class="search_table"><!-- search_table start -->
<form id="MainForm" method="get" action="">

<input type ="hidden" id="paramAccCodeId"  name="paramAccCodeId"  value=""/>
<input type ="hidden" id="paramAccCode"    name="paramAccCode"    value=""/>
<input type ="hidden" id="paramAccDesc"    name="paramAccDesc"    value=""/>
<input type ="hidden" id="paramSapAccCode" name="paramSapAccCode" value=""/>
<input type ="hidden" id="parmIsPayCash"   name="parmIsPayCash"   value=""/>
<input type ="hidden" id="parmIsPayChq"    name="parmIsPayChq"    value=""/>
<input type ="hidden" id="parmIsPayOnline" name="parmIsPayOnline" value=""/>
<input type ="hidden" id="parmIsPayCrc"    name="parmIsPayCrc"    value=""/>
<input type ="hidden" id="parmAddEditFlag" name="parmAddEditFlag" value=""/>
<input type ="hidden" id="parmAddCntyId"   name="parmAddCntyId" value=""/>
<input type ="hidden" id="paramAddStateId" name="paramAddStateId" value=""/>
<input type ="hidden" id="paramAddAreaId"  name="paramAddAreaId" value=""/>
<input type ="hidden" id="pramAddPostCodeId" name="pramAddPostCodeId" value=""/>

<table class="type1"><!-- table start -->
<caption>table</caption>
<colgroup>
	<col style="width:180px" />
	<col style="width:*" />
	<col style="width:180px" />
	<col style="width:*" />
	<col style="width:180px" />
	<col style="width:*" />
</colgroup>
<tbody>
<tr>
	<th scope="row">Account ID</th>
	<td>
	<input type="text" id="accId" name="accId" title="" placeholder="" class="w100p" />
	</td>
	<th scope="row">Account Code</th>
	<td>
	<input type="text" id="accCode" name="accCode" title="" placeholder="" class="w100p" />
	</td>
	<th scope="row">Account Description</th>
	<td>
	<input type="text" id="accDesc" name="accDesc" title="" placeholder="" class="w100p" />
	</td>
</tr>
<tr>
	<th scope="row">SAP Code</th>
	<td>
	<input type="text" id="sapAccCode" name="sapAccCode" title="" placeholder="" class="w100p" />
	</td>
	<th scope="row">Status</th>
	<td>
	<select class="w100p" id="accStusId" name="accStusId">
		<option value="0">ALL</option>
		<option value="1" selected>Active</option>
		<option value="8">Inactive</option>
	</select>
	</td>
	<th scope="row">Payment Key-In</th>
	<td>
	<select class="w100p" id="paymentCd" name="paymentCd" >
		<option value="">--- Payment Key-In Account ---</option>
		<option value="CHQ">Cheque</option>
		<option value="CRC">Credit Card</option>
		<option value="CSH">Cash</option>
		<option value="ONL">Online</option>
	</select>
	</td>
</tr>
</tbody>
</table><!-- table end -->

<aside class="link_btns_wrap"><!-- link_btns_wrap start -->
  <p class="show_btn"><%-- <a href="#"><img src="${pageContext.request.contextPath}/resources/images/common/btn_link.gif" alt="link show" /></a> --%>
  </p> 
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
	<p class="hide_btn"><a href="javascript:;"><img src="${pageContext.request.contextPath}/resources/images/common/btn_link_close.gif" alt="hide" /></a></p>
	</dd>
</dl>
</aside><!-- link_btns_wrap end -->

</form>
</section><!-- search_table end -->

<section class="search_result"><!-- search_result start -->

<ul class="right_btns">
	<li><p class="btn_grid"><a href="javascript:;" onclick="editPopUp();">EDIT</a></p></li>
	<li><p class="btn_grid"><a href="javascript:;" onclick="addPopUp();">ADD</a></p></li>
</ul>

<article class="grid_wrap"><!-- grid_wrap start -->
 <div id="MasterGrid"></div>
</article><!-- grid_wrap end -->

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