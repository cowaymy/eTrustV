<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp" %>


<style type="text/css">
/* 엑스트라 체크박스 사용자 선택 못하는 표시 스타일 */
.disable-check-style {
    color:#d3825c;
}
.my-inactive-style {
    background:#efcefc;
   /* text-align:right;*/

}
.my-column-style3 {
    color:#0000ff;
}

.my_div {
    display:inline-block;
    margin-top:7px;
    color:#0000ff;
}

.my_div_text_box {
    display: inline-block;
    border: 1px solid #aaa;
    text-align: left;
    width: 140px;
    padding: 4px;
}
.my_div_btn {
    color: #fff !important;
    background-color: #2a2d33;
    font-weight: bold;
    margin: 2px 4px;
    padding : 2px 4px;
    line-height:2em;
    cursor: pointer;
}

</style>

<script type="text/javascript" src="${pageContext.request.contextPath}/resources/js/jquery.blockUI.min.js"></script>
<script type="text/javaScript" language="javascript">



var listGrid;
var subGrid;
var detailList;

var groupList = [" ", "A", "B", "C" ];


var rescolumnLayout=[

			                     {dataField: "srono",headerText :"SRO No."           ,width:230    ,height:30     },
			                     {dataField: "reqstus",headerText :"reqstus"           ,width:230    ,height:30 ,visible:false    },

			                     {dataField: "sroreqno",headerText :"Ref.No(STO/SMO)",width:170    ,height:30,

			                    	 renderer : { // HTML 템플릿 렌더러 사용
                                         type : "TemplateRenderer"
                                     },
                                     // dataField 로 정의된 필드 값이 HTML 이라면 labelFunction 으로 처리할 필요 없음.
                                     labelFunction : function (rowIndex, columnIndex, value, headerText,    item ) { // HTML 템플릿 작성

                                    	 //console.log(item);
                                        // if(!value)  return "";
                                         var template = '<div class="my_div" >';

                                         if( null != item.sroreqno){

                                        	 var  po = {sroreqno:item.sroreqno, srotype:item.srotype };

                                        	 var a  = item.sroreqno;
                                        	 var b  = item.srotype;
                                             template += '<span  onclick="javascript:fn_doPopup( \' '+a +' \'  ,  \' '+b+'  \');">' + item.sroreqno ;


                                        	 template += '<span style="text-align:right; color:red;">'

                                        	 if(item.reqstdelyn =='Y'){
                                        		 template +=  "(Deleted) </span> </span> " ;
                                        	 }else{
                                        		 template +=  "("+ item.reqstus+") </span> </span> " ;
                                        	 }
	                                     }
                                         template += '</div>';

                                         return template; // HTML 템플릿 반환..그대도 innerHTML 속성값으로 처리됨
                                     }
			                     },
			                     {dataField: "srostacd",headerText :"<spring:message code='log.head.status'/>",width:100    ,height:30      ,visible:false           },
			                     {dataField: "sromsg",headerText :"Remark",width:250    ,height:30                },
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
			                     {dataField: "rowno",headerText :"<spring:message code='log.head.rownum'/>",width:120    ,height:30 , visible:false},
			                     {dataField: "srono",headerText :"SRO No."           ,width:200    ,height:30                },
			                     {dataField: "sroitmstatecd",headerText :"<spring:message code='log.head.status'/>",width:80    ,height:30   ,editable : false                },
                                 {dataField: "srotype",headerText :"SRO Type"           ,  width:120    ,height:30           },
			                     {dataField: "srostkcode",headerText :"Mat.Code"                  ,width:80    ,height:30             ,editable : false   },
			                     {dataField: "stkdesc",headerText :"Mat.Name"                      ,width:220    ,height:30             ,editable : false   },
                              //   {dataField: "srofravlqty",headerText :"(Fr) Old</br>Available Qty"         ,width:120    ,height:30            ,editable : false  },
                                 {dataField: "srosupqty",headerText :"Supply Qty"                  ,width:120    ,height:30         ,editable : false  ,dataType : "numeric"  },
                                 {dataField: "sroconqty",headerText :"Confirm </br>Supply Qty"       ,width:120    ,height:30 ,style  :"my-inactive-style"        ,editable : false,dataType : "numeric"  },
                                 {dataField: "srofulqty" ,headerText :"Unfulfilled </br>Qty"               ,width:120    ,height:30             ,editable : false,dataType : "numeric"   },
                                 {dataField: "srofravailqtyorg" ,headerText :"(Fr)Current Available </br>Qty"         ,       width:120    ,height:30       ,     editable : false,formatString : "#,###,###",

                                	 renderer : { // HTML 템플릿 렌더러 사용
                                         type : "TemplateRenderer"
                                     },
                                     // dataField 로 정의된 필드 값이 HTML 이라면 labelFunction 으로 처리할 필요 없음.
                                     labelFunction : function (rowIndex, columnIndex, value, headerText, item ) { // HTML 템플릿 작성

                                        // if(!value)  return "";
                                         var template = '<div class="my_div" >';
                                         // 이름이 "Anna" 또는 "Emma" 인 경우 체크 설정하기
                                         if(item.srofravailqtyorg   > 0 ) {
                                        	       template += '<span style="text-align:right; color:red;"   >'
                                                   template += "("+ AUIGrid.formatNumber(item.sroconqty,"#,##0") +") </span>  / " ;

                                         }else{
                                        	    if ( item.sroconqty >0 ){
                                                       template += '<span style="text-align:right; color:red;"   >'
                                                        template += "("+ AUIGrid.formatNumber(item.sroconqty,"#,##0") +") </span>  / " ;
                                        	    }
                                         }


                                         template += '<span style=" text-align:right; vertical-align: middle;height: 0px;">'
                                         template += AUIGrid.formatNumber( (item.srofravailqtyorg ),"#,##0");

                                         template += '</span></div>';
                                         return template; // HTML 템플릿 반환..그대도 innerHTML 속성값으로 처리됨
                                     }


                                 },
                                 {dataField: "requestqty" ,headerText :"Request Qty"               ,width:120    ,height:30   ,editable : true  ,dataType : "numeric"    },
                            //     {dataField: "srofrnowavlqty" ,headerText :"(Fr)Currently</br> Available Qty" ,width:120    ,height:30   ,style  :"my-inactive-style"   ,editable : false},
                                 {dataField: "generate", headerText :"Generate" ,width:120 , editable : false,
	                                	renderer : { // HTML 템플릿 렌더러 사용
	                                         type : "TemplateRenderer"
	                                   },
                                	   labelFunction : function (rowIndex, columnIndex, value, headerText, item ) { // HTML 템플릿 작성

                                		   var template="";
                                		    if(item.generate =="generate"   &&  item.srosupqty >0){

                                		    	 template += '<div class="my_div">';
                                                 template += '<span class="my_div_btn" onclick="javascript:fn_generateClick();"> Generate </span>';
                                                 template += '</div>';
                                		    }
                                		    return template; // HTML 형식의 스트링
                                		}
                                 },
			                     {dataField: "srorefsrono",headerText :"Ref.SRO No"                  ,width:120    ,height:30               ,editable : false },
			                     {dataField: "sroitmresultmsg",headerText :"Result Massage"                  ,width:270    ,height:30               ,editable : false },
                                 {dataField: "crtdt",headerText :"Create Date"       , dataType : "date",           width:120    ,height:30     ,    formatString : "dd/mm/yyyy"     },
                                 {dataField: "srobasqty",headerText :"(To)Basic </br>Qty"                  ,width:120    ,height:30              ,editable : false ,visible:false },
                                 {dataField: "srorordpot",headerText :"(To)ReOrder</br> Ponit"                  ,width:120    ,height:30               ,editable : false ,visible:false},
                                 {dataField: "sroaddpot",headerText :"(To)additional</br> Point"                  ,width:120    ,height:30               ,editable : false ,visible:false},
                                 {dataField: "sroitmlev",headerText :"item idex"                  ,width:120    ,height:30               ,editable : false  ,visible:false},
                                 {dataField: "srofravailqtyorg",headerText :"srofravailqtyorg"                  ,width:120    ,height:30               ,editable : false  ,visible:false},
                                 {dataField: "srocalautoreplenqty",headerText :"srocalautoreplenqty"                  ,width:120    ,height:30               ,editable : false  ,visible:false},


                     ];



					var detailLayout=[
					                                {dataField: "srono",headerText :"SRO No."           ,width:120    ,height:30                },
													{dataField: "srostkcode",headerText :"Mat.Code"                  ,width:80    ,height:30               ,editable : false  },
													{dataField: "stkdesc",headerText :"Mat.Name"                  ,width:170    ,height:30               ,editable : false   },
					                                {dataField: "srosupqty",headerText :"Supply Qty"                  ,width:80    ,height:30         ,editable : false  ,dataType : "numeric" },
													{dataField: "sroitmstatecd",headerText :"<spring:message code='log.head.status'/>",width:80    ,height:30   ,editable : false                },
					                                {dataField: "srorefsrono",headerText :"Ref.SRO No"                  ,width:120    ,height:30               ,editable : false },
					                                {dataField: "srobasqty",headerText :"Basic Qty"                  ,width:120    ,height:30               ,editable : false  ,dataType : "numeric"  },
													{dataField: "sroreordpot",headerText :"ReOder <br>Point(%)"                  ,width:100    ,height:30               ,editable : false  ,dataType : "numeric" },
													{dataField: "sroreordrangeqty",headerText :"ReOder Range Qty <br> (Basic Qty / (100/ReOrder Point ) )"                  ,width:120    ,height:30        ,dataType : "numeric"        ,editable : false  },
                                                    {dataField: "srominnumqty",headerText :"Minimum Qty <br> (Basic Qty - ReOrder Range Qty)"                  ,width:120    ,height:30           ,dataType : "numeric"     ,editable : false },
                                                    {dataField: "srotoavailqty",headerText :"To Ware House <br> Available Qty"                                            ,width:120    ,height:30         ,dataType : "numeric"       ,editable : false },
													{dataField: "srofravlqty",headerText :"Fr Ware House <br> Available Qty"                                            ,width:120    ,height:30         ,dataType : "numeric"       ,editable : false },
	                                                {dataField: "sroautoreplenqty",headerText :"Auto Replenishment <br> Qty"                  ,width:120    ,height:30,  style  :"my-inactive-style"            ,dataType : "numeric"      ,editable : false },
	                                                {dataField: "srocenautoreplenqty",headerText :"Auto Replenishment <br> Cencal Qty"                  ,width:120    ,height:30,  style  :"my-inactive-style"            ,dataType : "numeric"      ,editable : false },

	                                                {dataField: "crtdt",headerText :"Create Date"       , dataType : "date",           width:120    ,height:30     ,    formatString : "dd/mm/yyyy"     },
	                                                {dataField: "sroitmresultmsg",headerText :"Result Massage"                  ,width:270    ,height:30               ,editable : false },
	                                                {dataField: "reqstdel",headerText :"reqstdel"                  ,width:50    ,height:30               ,editable : false  ,visible:false},




					]

					var footerLayout = [
												{  labelText : "∑",
												    positionField : "#base"
												  }
												, {
                                                    dataField : "srofravlqty",
                                                    positionField : "srofravlqty",
                                                    operation : "SUM",
                                                    formatString : "#,##0",
                                                    colSpan : 8
                                                }
												, {
                                                    dataField : "srotoavailqty",
                                                    positionField : "srotoavailqty",
                                                    operation : "SUM",
                                                    formatString : "#,##0"
                                                }
											   , {
												    dataField : "sroautoreplenqty",
												    positionField : "sroautoreplenqty",
												    operation : "SUM",
												    formatString : "#,##0"
												}
					 ]


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
            copySingleCellOnRowMode:true,
            // 고정칼럼 카운트 지정
            fixedColumnCount : 3
    };



   var dProps = {
	        rowIdField : "rowno",
		    showStateColumn : true,
            selectionMode : "singleRow",
            useContextMenu : true,
		    rowHeight : 30,
		    headerHeight : 40,
		    enableSorting :true,
		    editable:true,
		    copySingleCellOnRowMode:true,
            showRowCheckColumn : true,
            displayTreeOpen : true,
            independentAllCheckBox : true,

            // 이 함수는 사용자가 체크박스를 클릭 할 때 1번 호출됩니다.
            rowCheckableFunction : function(rowIndex, isChecked, item) {
                if(item.srofulqty <=0  || item.sroitmstatecd =='Complete' || item.sroitmstatecd =='Terminated' ) {
                	  Common.alert("Don't  delete the sro data. ");
                	 return false;
                }
                return true;
            },

            rowCheckDisabledFunction : function(rowIndex, isChecked, item) {
                if(item.srofulqty <=0  || item.sroitmstatecd =='Complete'  || item.sroitmstatecd =='Terminated'  ) { // 제품이 LG G3 인 경우 체크박스 disabeld 처리함
                    return false; // false 반환하면 disabled 처리됨
                }
                return true;
            },


		    // 고정칼럼 카운트 지정
            fixedColumnCount : 5
   };

   var detailProps = {
		   selectionMode : "singleRow",
           rowHeight : 30,
           headerHeight : 40,
           editable:false,
           copySingleCellOnRowMode:true,
           // 고정칼럼 카운트 지정
           fixedColumnCount : 5
  };


	//var resop = {rowIdField : "rnum", showRowCheckColumn : false ,usePaging : true,useGroupingPanel : false , Editable:false};
	var reqop = {usePaging : true,useGroupingPanel : false , editable:false ,copySingleCellOnRowMode:true};


    listGrid   = GridCommon.createAUIGrid("#main_grid_wrap", rescolumnLayout, '',auiGridProps);
    subGrid  = AUIGrid.create("#sub_grid_wrap", reqcolumnLayout ,dProps);

    detailList = GridCommon.createAUIGrid("#detail_grid_wrap", detailLayout ,'',detailProps);

    AUIGrid.setFooter(detailList, footerLayout);



   AUIGrid.bind(listGrid, "cellDoubleClick", function(event){
    	if(event.dataField  =="sroreqno" ){
    	}else{
    		$('#tabitem').click();
    	}
    });



    // 체크박스 클린 이벤트 바인딩
    AUIGrid.bind(subGrid, "rowCheckClick", function( event ) {
         // alert("rowIndex : " + event.rowIndex + ", id : " + event.item.id + ", name : " + event.item.name + ", checked : " + event.checked);
    });

     // 전체 체크박스 클릭 이벤트 바인딩
    AUIGrid.bind(subGrid, "rowAllChkClick", function( event ) {

    		if(event.checked) {
	            // name 의 값들 얻기
	            var  gridRows = AUIGrid.getGridData(event.pid);
	            var rowIdField = AUIGrid.getProp(event.pid, "rowIdField");
	            var items = [];
                    gridRows.forEach(function(v, n ,item) {
                    	 if(v.sroitmstatecd ='Active' && v.srofulqty >0 ){
                             items.push(v.rowno);
                    	 }
	                });
                 //console.log(items);
                 AUIGrid.setCheckedRowsByIds(event.pid, items);

    		} else {
	            AUIGrid.setCheckedRowsByValue(event.pid, "srofulqty", []);
	        }
    });



    AUIGrid.bind(subGrid, "cellDoubleClick", function(event){

	   $("#gropenwindow").show();
       AUIGrid.resize(detailList);
       fn_setPopDetailData();

    });


   AUIGrid.bind(subGrid, "cellEditEnd", function( event ) {
    	if(event.item.srofulqty  <  event.value){
            Common.alert("it cannot be larger than supply quantity. ");
            AUIGrid.setCellValue(subGrid, event.rowIndex, "requestqty", event.oldValue);
        }else{
        	//console.log(event);
        }
   });


});



 function fn_doPopup (sroreqno ,srotype ){

	if(sroreqno.trim() ==null) return ;

    if(srotype.trim()  =="STO"){
    	var  popupObj = Common.popupWin("popSTO", "/logistics/stocktransfer/StocktransferList.do?streq="+sroreqno.trim() , {width : "1000px", height : "720", resizable: "no", scrollbars: "yes"});
    }else if( srotype =="SMO"){
    	var  popupObj = Common.popupWin("popSMO", "/logistics/stockMovement/StockMovementList.do?streq="+sroreqno.trim(), {width : "1000px", height : "720", resizable: "no", scrollbars: "yes"});
    }
}








//리스트 조회.
fn_getDataListAjax  = function () {
    AUIGrid.clearGridData(subGrid);

    //$('#tabitem').click();

    Common.ajax("GET", "/logistics/sro/sroMgmtList.do", $("#searchForm").serialize(), function(result) {
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

	   // console.log(result);
	    Common.alert("generate is  success </br> "+"Ref No["+result.data+"]");

	    fn_getDataItemListAjax();
	});

}

//btn clickevent
$(function(){

     $('#search').click(function() {

    	 // $('#tabitem').removeClass("on");
    	 // $('#tabmst').attr("class","on");

    	  $('#tabmst').click();

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

     $('#delete').click(function() {
         fn_doDelete();
     });

     $('#download_main').click(function() {
    	 fn_gridExport('main_grid');
     });

     $('#download_sub').click(function() {
    	 fn_gridExport('sub_grid');
     });


});



//리스트 조회.
fn_getDataItemListAjax  = function () {

	var selectedItems = AUIGrid.getSelectedItems(listGrid)

	if( selectedItems != "undefined"){
    		var p={ srono: selectedItems[0].item.srono};
	        Common.ajax("GET", "/logistics/sro/sroMgmtDetailList.do",p, function(result) {
	         //  console.log("성공.");
	           //console.log("data : " + result);
	         //  console.log(result);
	           AUIGrid.setGridData(subGrid, result);
	        });
	}
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



function fn_setPopDetailData() {


		var selectedItems = AUIGrid.getSelectedItems(subGrid)
	    var p={ srono: selectedItems[0].item.srono,srostkcode:selectedItems[0].item.srostkcode };


	    Common.ajax("GET", "/logistics/sro/sroMgmtDetailListPopUp.do", p,  function(result) {
		    	       AUIGrid.setGridData(detailList, result);
		});
}



function fn_generateClick(){
    Common.confirm("Do you want to generate ?", fn_doGgenerate);
}


function fn_doDelete(){


	var checkedItems = AUIGrid.getCheckedRowItems(subGrid);

	var  deleteForm = {
		        "remove" : checkedItems
	}

	//console.log(deleteForm);

	if(checkedItems.length <= 0) {
        Common.alert("no selected item.");
        return;
    }

    Common.ajax("POST", "/logistics/sro/deleteSroMgmt.do",deleteForm, function(result) {
     //  console.log("성공.");
       //console.log("data : " + result);
       //console.log(result);
       //AUIGrid.setGridData(subGrid, result);
    });


}

fn_gridExport =function (type){

	if(type == 'main_grid'){
        GridCommon.exportTo("main_grid_wrap", "xlsx", "sro_list_excel");
    }else if (type == 'sub_grid'){
        GridCommon.exportTo("sub_grid_wrap", "xlsx", "sro_item_excel");
    }
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
			    <select class="w100p" id="flocation" name="flocation"></select>
			    </td>
			    <th scope="row">To Location</th>
			    <td >
			    <select class="w100p" id="tlocation" name="tlocation"></select>
			    </td>
			</tr>


            </tbody>
        </table><!-- table end -->
    </form>

    </section><!-- search_table end -->


      <section class="tap_wrap"><!-- tap_wrap start -->
        <ul class="tap_type1">
            <li><a href="#" id ="tabmst"class="on">SRO MasterList</a></li>
            <li><a href="#"  id="tabitem">SRO Master ItemList</a></li>
        </ul>



        <article class="tap_area"><!-- tap_area start -->

          <ul class="right_btns">
                <li><p class="btn_grid"><a id="download_main" ><spring:message code='sys.btn.excel.dw' /></a></p></li>
         </ul>

            <article class="grid_wrap"><!-- grid_wrap start -->
                  <div id="main_grid_wrap" class="mt10" style="height:450px"></div>
            </article><!-- grid_wrap end -->

        </article><!-- tap_area end -->

        <article class="tap_area"><!-- tap_area start -->

         <ul class="right_btns">
                <li><p class="btn_grid"><a id="download_sub" ><spring:message code='sys.btn.excel.dw' /></a></p></li>
                <li><p class="btn_grid"><a id="delete">Delete</a></p></li>
         </ul>
            <article class="grid_wrap"><!-- grid_wrap start -->
                 <div id="sub_grid_wrap"  class="mt10" style="height:450px"></div>
            </article><!-- grid_wrap end -->
        </article><!-- tap_area end -->

    </section><!-- tap_wrap end -->




<div class="popup_wrap" id="gropenwindow" style="display:none ;height:550px; " ><!-- popup_wrap start -->
        <header class="pop_header"><!-- pop_header start -->
            <h1 id="dataTitle">Auto Replenishment Detail DataList</h1>
            <ul class="right_opt">
                <li><p class="btn_blue2"><a href="#">CLOSE</a></p></li>
            </ul>
        </header><!-- pop_header end -->

            <section class="pop_body"><!-- pop_body start -->



					<section class="search_table"><!-- search_table start -->

					        <table summary="search table" class="type1"><!-- table start -->
					            <caption>search table</caption>
					            <colgroup>
					                <col style="width:*" />
					            </colgroup>
					            <tbody>
					                <tr>
					                    <th scope="row" style="text-align:right;"> <b>Supply Qty :</b>   </th>
					                       <td scope="row" style="text-align:right;">
                                                <span  style="color:red;"> Minimum Qty  > To Ware House Qty  :   (Basic Qty -  To Ware House Qty  )</span>
						                  </td>
					                </tr>
					            </tbody>
					        </table><!-- table end -->

					    </section><!-- search_table end -->




	       		<article class="grid_wrap "><!-- grid_wrap start -->
			     <div id="detail_grid_wrap" style="width:100%; height:550px;"></div>
			</article><!-- grid_wrap end -->
        </section>
</div>

</section>

 <form id="popSMO" name="popSMO" action="#" method="post">
 </form>

  <form id="popSTO" name="popSTO" action="#" method="post">
 </form>
