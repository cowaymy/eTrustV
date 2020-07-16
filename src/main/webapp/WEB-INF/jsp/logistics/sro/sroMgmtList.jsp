<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp" %>


<style type="text/css">
.pnum {
    font-weight:bold;
}

/* 커스텀 스타일 */
.left {
    text-align:left;
}

/* 그리드 오버 시 행 선택자 만들기 */
.aui-grid-body-panel table tr:hover {
    background:#D9E5FF;
    color:#000;
}
.aui-grid-main-panel .aui-grid-body-panel table tr td:hover {
    background:transparent;
    color:#000;
}

.my-inactive-style {
    background:#efcefc;
}


/* 커스텀 칼럼 스타일 정의*/
.myLinkStyle {
    text-decoration: underline;
    color:#4374D9;
}


/* 커스컴 disable 스타일*/
.mycustom-disable-color {
    color : #4374D9;
}

</style>

<script type="text/javascript" src="${pageContext.request.contextPath}/resources/js/jquery.blockUI.min.js"></script>
<script type="text/javaScript" language="javascript">



var listGrid;
var subGrid;


var groupList = [" ", "A", "B", "C" ];


var rescolumnLayout=[

			                     {dataField: "srono",headerText :"SRO No."           ,width:230    ,height:30           ,
			                    	 editRenderer : {
			                    	     type : "InputEditRenderer",

			                    	     // ID는 고유값만 가능하도록 에디팅 유효성 검사
			                    	     validator : function(oldValue, newValue, rowItem, dataField) {
			                    	         if(oldValue != newValue) {
			                    	             // dataField 에서 newValue 값이 유일한 값인지 조사
			                    	             var isValid = AUIGrid.isUniqueValue(listGrid, dataField, newValue);

			                    	             // 리턴값은 Object 이며 validate 의 값이 true 라면 패스, false 라면 message 를 띄움
			                    	             return { "validate" : isValid, "message"  : newValue + " 값은 고유값이 아닙니다. 다른 값을 입력해 주십시오." };
			                    	         }
			                    	     }
			                    	 }
			                     },
			                     {dataField: "sroreqno",headerText :"Ref.No(STO/SMO)",width:150    ,height:30,

			                    	    style : "myLinkStyle",
			                            // LinkRenderer 를 활용하여 javascript 함수 호출로 사용하고자 하는 경우
			                            renderer : {
			                                type : "LinkRenderer",
			                                baseUrl : "javascript", // 자바스크립 함수 호출로 사용하고자 하는 경우에 baseUrl 에 "javascript" 로 설정
			                                // baseUrl 에 javascript 로 설정한 경우, 링크 클릭 시 callback 호출됨.
			                                jsCallback : function(rowIndex, columnIndex, value, item) {
			                                	fn_doPopup (item);
			                                }
			                            }
			                     },
			                     {dataField: "srostacd",headerText :"<spring:message code='log.head.status'/>",width:100    ,height:30                },
			                     {dataField: "sromatdocno",headerText :"Mat. Doc. No ",width:150    ,height:30                },
			                     {dataField: "srofrwlcd",headerText :"From Location <br> code"                  ,width:120    ,height:30                },
			                     {dataField: "srofrwldesc",headerText :"<spring:message code='log.head.fromlocation'/>"                  ,width:150    ,height:30                },
			                     {dataField: "srotowlcd",headerText :"To Location <br>code"                  ,width:100    ,height:30                },
			                     {dataField: "srotowldesc",headerText :"<spring:message code='log.head.tolocation'/>"                  ,width:150    ,height:30                },
			                     {dataField: "srorefsrono",headerText :"Ref.SRO No."                  ,width:150    ,height:30                },
                                 {dataField: "srotype",headerText :"SRO Type"           ,  width:120    ,height:30           },

			                     {dataField: "srocrtdt",headerText :"Create Date"       , dataType : "date",           width:120    ,height:30     ,    formatString : "dd/mm/yyyy"           }
			                  ];

var reqcolumnLayout=[
			                     {dataField: "rnum",headerText :"<spring:message code='log.head.rownum'/>",width:120    ,height:30 , visible:false},
			                     {dataField: "srono",headerText :"SRO No."           ,width:200    ,height:30                },
			                     {dataField: "sroitmstatecd",headerText :"<spring:message code='log.head.status'/>",width:80    ,height:30   ,editable : false                },
			                     {dataField: "srostkcode",headerText :"Mat.Code"                  ,width:80    ,height:30             ,editable : false   },
			                     {dataField: "stkdesc",headerText :"Mat.Name"                      ,width:220    ,height:30             ,editable : false   },
                                 {dataField: "srofravlqty",headerText :"(Fr) Old</br>Available Qty"         ,width:120    ,height:30            ,editable : false  },
                                 {dataField: "srosupqty",headerText :"Supply Qty"                  ,width:120    ,height:30         ,editable : false },
                                 {dataField: "sroconqty",headerText :"Confirm </br>Supply Qty"       ,width:120    ,height:30         ,editable : false },
                                 {dataField: "srofulqty" ,headerText :"Unfulfilled </br>Qty"               ,width:120    ,height:30   ,style  :"my-inactive-style"              ,editable : false},
                                 {dataField: "requestqty" ,headerText :"Request Qty"               ,width:120    ,height:30   ,style  :"my-inactive-style"       ,editable : true     },
                                 {dataField: "srofrnowavlqty" ,headerText :"(Fr)Currently</br> Available Qty" ,width:120    ,height:30   ,style  :"my-inactive-style"   ,editable : false},
                                 {dataField: "generate", headerText :"Generate" ,width:120 , editable : false,  styleFunction : cellStyleFunction,

                                	 renderer : {
                                		 type : "IconRenderer",
                                         iconWidth : 30,
                                         iconHeight : 30,
                                         iconFunction : function(rowIndex, columnIndex, value, item) {
                                        	   var icon = "${pageContext.request.contextPath}/resources/AUIGrid/images/flat_orange_circle.png";

                                        	   if(item.generate =="generate"){
	                                        		   icon ="${pageContext.request.contextPath}/resources/AUIGrid/images/flat_blue_circle.png";
                                        	   }else{
                                        	   }
                                        	   // 로직 처리
                                        	   return icon;
                                        },
                                        onclick : function(rowIndex, columnIndex, value, item) {

                                        	   if(item.sroitmlev > 1){

                                        		   Common.alert("상위 SRO에서 처리 가능합니다. <br>  상위 SRO NO: "+item.srorefsrono);
                                        		   return ;
                                        	   }

                                        	   if(item.generate =="generate"){
                                        	        Common.confirm("Do you want to generate ?",fn_doGgenerate);
                                        	   }else {
                                        		  Common.alert("Available quantity is insufficient");
                                        		   return ;
                                        	   }
                                        }
                                	 }
                                 },
			                     {dataField: "srotoavlqty",headerText :"(To)Available </br>Qty"                  ,width:120    ,height:30              ,editable : false ,visible:false },
			                     {dataField: "srobasqty",headerText :"(To)Basic </br>Qty"                  ,width:120    ,height:30              ,editable : false  },
			                     {dataField: "srorordpot",headerText :"(To)ReOrder</br> Ponit"                  ,width:120    ,height:30               ,editable : false },
                                 {dataField: "sroaddpot",headerText :"(To)additional</br> Point"                  ,width:120    ,height:30               ,editable : false },
                                 {dataField: "sroitmlev",headerText :"item idex"                  ,width:120    ,height:30               ,editable : false  ,visible:false},
                                 {dataField: "srorefsrono",headerText :"Ref.SRO No"                  ,width:120    ,height:30               ,editable : false },
                                 {dataField: "srotype",headerText :"SRO Type"           ,  width:120    ,height:30           },
                                 {dataField: "crtdt",headerText :"Create Date"       , dataType : "date",           width:120    ,height:30     ,    formatString : "dd/mm/yyyy"     },

                     ];



$(document).ready(function(){

	doSysdate(0 , 'crtsdt');
	doSysdate(0 , 'crtedt');
	paramdata = {stoIn:'01,02,05,06,07', grade:$("#locationType").val() };
	doGetComboCodeId('/common/selectStockLocationList.do', paramdata, '','tlocation', 'S' , 'fn_setDefaultSelection');
	doGetComboCodeId('/common/selectStockLocationList.do', {stoIn:'01,02,05,07' , grade:$("#locationType").val()}, '','flocation', 'S' , '');



	var auiGridProps = {

            // singleRow 선택모드
            selectionMode : "singleRow",
            headerHeight : 40,

            displayTreeOpen : true,

            editable : false,

            // 일반 데이터를 트리로 표현할지 여부(treeIdField, treeIdRefField 설정 필수)
            flat2tree : true,

            // 행의 고유 필드명
            rowIdField : "rowno",

            // 트리의 고유 필드명
            treeIdField : "srono",

            // 계층 구조에서 내 부모 행의 treeIdField 참고 필드명
            treeIdRefField : "srorefsrono",
            copySingleCellOnRowMode:true
    };



   var dProps = {
		   showStateColumn : true,
		    rowHeight : 30,
		    headerHeight : 40,
		    showRowCheckColumn : false,
		    enableSorting :true,
		    editable:true,
		    copySingleCellOnRowMode:true
   };




	//var resop = {rowIdField : "rnum", showRowCheckColumn : false ,usePaging : true,useGroupingPanel : false , Editable:false};
	var reqop = {usePaging : true,useGroupingPanel : false , editable:false ,copySingleCellOnRowMode:true};


    listGrid   = GridCommon.createAUIGrid("#main_grid_wrap", rescolumnLayout, '',auiGridProps);
    subGrid  = AUIGrid.create("#sub_grid_wrap", reqcolumnLayout ,dProps);



   AUIGrid.bind(listGrid, "cellDoubleClick", function(event){
    	if(event.dataField  =="sroreqno" ){
    	}else{
    		$('#tabitem').click();
    	}
    });



   AUIGrid.bind(subGrid, "cellEditEnd", function( event ) {
    	if(event.item.srofulqty  <  event.value){
            Common.alert("it cannot be larger than supply quantity. ");
            AUIGrid.setCellValue(subGrid, event.rowIndex, "requestqty", event.oldValue);
        }else{
        	//console.log(event);
        }
   });

   AUIGrid.bind(subGrid, "cellClick", function( event ) {
		   if(event.dataField =="generate"){
	           if(event.item.sroitmlev > 1){
	               Common.alert("상위 SRO에서 처리 가능합니다. <br>  상위 SRO NO: "+event.item.srorefsrono);
	               return ;
	           }
	           if(event.item.generate =="generate"){
	                Common.confirm("Do you want to generate ?",fn_doGgenerate);
	           }else {
	              Common.alert("Available quantity is insufficient");
	               return ;
	           }
		   }
	});

});



fn_doPopup = function(item){

	if(item.sroreqno ==null) return ;
    if(item.srotype =="STO"){
           var  popupObj = Common.popupWin("popSTO", "/logistics/stocktransfer/StocktransferList.do?streq="+item.sroreqno , {width : "1000px", height : "720", resizable: "no", scrollbars: "yes"});
    }else if(item.srotype =="SMO"){
           var  popupObj = Common.popupWin("popSMO", "/logistics/stockMovement/StockMovementList.do?streq="+item.sroreqno, {width : "1000px", height : "720", resizable: "no", scrollbars: "yes"});
    }
}





/**셀스타일 함수 정의*/
function cellStyleFunction( rowIndex, columnIndex, value, headerText, item, dataField) {

    //console.log(item)
    if(item.generate =="generate"){
    	return "mycustom-disable-color";
    }

    return null;
};


//리스트 조회.
fn_getDataListAjax  = function () {

  Common.ajax("GET", "/logistics/sro/sroMgmtList.do", $("#searchForm").serialize(), function(result) {
   //  console.log("성공.");
     //console.log("data : " + result);
   // console.log(result);
     AUIGrid.setGridData(listGrid, result);
 });
}




fn_validation =function(){

    // 수정, 추가한 행에 대하여 검사
    // name 과 country 는 필수로 입력되어야 하는 필드임. 이것을 검사
   // var isValid = AUIGrid.validateChangedGridData(myGridID, ["name", "country"], "반드시 유효한 값을 직접 입력해야 합니다.");
    return true;
}




fn_doGgenerate =function (){

	 var selectedItems = AUIGrid.getSelectedItems(subGrid)

	Common.ajax("GET", "/logistics/sro/saveSroMgmt.do", selectedItems[0].item, function(result) {

	    console.log(result);
	    Common.alert("generate is  success </br> "+"Ref No["+result.data+"]");

	    fn_getDataItemListAjax();
	});

}

//btn clickevent
$(function(){

     $('#search').click(function() {
          if(fn_validation()) {
              fn_getDataListAjax();
          }
      });

     $('#clear').click(function() {
         window.location.reload();
     });

     $('#tabitem').click(function() {
          fn_getDataItemListAjax();
     });

});



//리스트 조회.
fn_getDataItemListAjax  = function () {

	var selectedItems = AUIGrid.getSelectedItems(listGrid)
    var p={ srono: selectedItems[0].item.srono};

	Common.ajax("GET", "/logistics/sro/sroMgmtDetailList.do",p, function(result) {
	 //  console.log("성공.");
	   //console.log("data : " + result);
	   console.log(result);
	   AUIGrid.setGridData(subGrid, result);
	});


}




function fn_setDefaultSelection() {

    Common.ajax("GET", "/logistics/stocktransfer/selectDefLocation.do", '',
            function(result) {
                //console.log(result.data);
                if (result.data != null || result.data != "") {
                   // $("#tlocation option[value='" + result.data + "']").attr("selected", true);

                } else {
                  //  $("#tlocation option[value='']").attr("selected", true);
                }
            });
}


</script>



<section id="content"><!-- content start -->
<ul class="path">
    <li><img src="${pageContext.request.contextPath}/resources/images/common/path_home.gif" alt="Home" /></li>
    <li>logistics</li>
    <li>Auto Replenishment  STO List</li>
</ul>

<aside class="title_line"><!-- title_line start -->
<p class="fav"><a href="#" class="click_add_on">My menu</a></p>
<h2>SRO List</h2>
</aside><!-- title_line end -->

<aside class="title_line"><!-- title_line start -->
<h3>Header Info</h3>
    <ul class="right_btns">

      <li><p class="btn_blue"><a id="search"><span class="search"></span>Search</a></p></li>

      <li><p class="btn_blue"><a id="clear"><span class="clear"></span>Clear</a></p></li>
    </ul>
</aside><!-- title_line end -->

<section class="search_table"><!-- search_table start -->
    <form id="searchForm" name="searchForm" method="post" onsubmit="return false;">

        <!-- menu setting -->
        <input type="hidden" name="CURRENT_MENU_CODE" value="${param.CURRENT_MENU_CODE}"/>
        <input type="hidden" name="CURRENT_MENU_FULL_PATH_NAME" value="${param.CURRENT_MENU_FULL_PATH_NAME}"/>
        <!-- menu setting -->

        <input type="hidden" id="svalue" name="svalue"/>
        <input type="hidden" id="sUrl"   name="sUrl"  />
        <input type="hidden" id="stype"  name="stype" />

        <input type="hidden" name="rStcode" id="rStcode" />
        <table summary="search table" class="type1"><!-- table start -->
            <caption>search table</caption>
            <colgroup>
                <col style="width:150px" />
                <col style="width:*" />
                <col style="width:160px" />
                <col style="width:*" />
                <col style="width:160px" />
                <col style="width:*" />
            </colgroup>
            <tbody>
                <tr>
                    <th scope="row">SRO No</th>
                    <td>
                        <!-- <select class="w100p" id="streq" name="streq"></select> -->
                        <input type="text" class="w100p" id="srono" name="srono">
                    </td>

                     <th scope="row">Status</th>
                    <td >
                        <select class="w100p" id="sstatus" name="sstatus">
                              <option selected value=""> ALL </option>
	                          <option  value="A"> Active </option>
	                          <option  value="C"> Complete</option>
                        </select>
                    </td>

                    <th scope="row">Create Date</th>
                    <td>
                        <div class="date_set w100p"><!-- date_set start -->
                        <p><input id="crtsdt" name="crtsdt" type="text" title="Create start Date" placeholder="DD/MM/YYYY" class="j_date"></p>
                        <span> To </span>
                        <p><input id="crtedt" name="crtedt" type="text" title="Create End Date" placeholder="DD/MM/YYYY" class="j_date"></p>
                        </div><!-- date_set end -->
                    </td>
                </tr>



			<tr>
			    <th scope="row">Location Grade </th>
			    <td>
			    <select class="w100p" id="locationType" name="locationType" >
			        <option selected value="A"> A </option>
			    </select></td>
			    <th scope="row">From Location</th>
			    <td >
			    <select class="w100p" id="tlocation" name="tlocation"></select>
			    </td>
			    <th scope="row">To Location</th>
			    <td >
			    <select class="w100p" id="flocation" name="flocation"></select>
			    </td>
			</tr>


            </tbody>
        </table><!-- table end -->
    </form>

    </section><!-- search_table end -->


      <section class="tap_wrap"><!-- tap_wrap start -->
        <ul class="tap_type1">
            <li><a href="#" class="on">SRO MasterList</a></li>
            <li><a href="#"  id="tabitem">SRO Master ItemList</a></li>
        </ul>

        <article class="tap_area"><!-- tap_area start -->
            <article class="grid_wrap"><!-- grid_wrap start -->
                  <div id="main_grid_wrap" class="mt10" style="height:450px"></div>
            </article><!-- grid_wrap end -->

        </article><!-- tap_area end -->

        <article class="tap_area"><!-- tap_area start -->

         <ul class="right_btns">
        </ul>
            <article class="grid_wrap"><!-- grid_wrap start -->
                 <div id="sub_grid_wrap"  class="mt10" style="height:450px"></div>
            </article><!-- grid_wrap end -->
        </article><!-- tap_area end -->

    </section><!-- tap_wrap end -->



</section>

 <form id="popSMO" name="popSMO" action="#" method="post">
 </form>

  <form id="popSTO" name="popSTO" action="#" method="post">
 </form>
