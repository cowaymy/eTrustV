<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>
<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="utf-8"/>
<meta content="width=1280px,user-scalable=yes,target-densitydpi=device-dpi" name="viewport"/>
<title>eTrust system</title>
<link rel="stylesheet" type="text/css" href="../css/master.css" />
<link rel="stylesheet" type="text/css" href="../css/common.css" />
<link rel="stylesheet" type="text/css" href="../css/multiple-select.css" />
<script type="text/javascript" src="../js/jquery-2.2.4.min.js"></script>
<script type="text/javascript" src="../js/jquery-ui.min.js"></script>
<script type="text/javascript" src="../js/jquery.ui.core.min.js"></script>
<script type="text/javascript" src="../js/jquery.ui.datepicker.min.js"></script>
<script type="text/javascript" src="../js/common_pub.js"></script>
<script type="text/javascript" src="../js/multiple-select.js"></script>
<script type="text/javascript" src="../js/jquery.mtz.monthpicker.js"></script>
</head>
<body>
    <script type="text/javaScript" language="javascript">

     var myCdGridID;
    var myCustGridID;
    var codyCd;


      // 체크된 아이템 얻기
	function fn_getCheckedRowItems() {

	    var checkedItems = AUIGrid.getCheckedRowItems(myCdGridID);

	    var str = [];
	    var rowItem = checkedItems[0].item;

/* 	    str = rowItem.memId; */

 	   str[0] = rowItem.memId;
	   str[1] = rowItem.codyId;

	   return str;
	}




/* 		// 체크된 아이템 얻기
	function fn_getCheckedCdRowItems() {
		    var checkedItems = AUIGrid.getCheckedRowItems(myCdGridID);
		    var str = "";
		    var rowItem;
		    var len = checkedItems.length;

		    if(len <= 0) {
		        alert("체크된 행 없음!!");
		        return;
		    }

		    for(var i=0; i<len; i++) {
		        rowItem = checkedItems[i];
		        str += "row : " + rowItem.rowIndex + ", id :" + rowItem.item.id + ", name : " + rowItem.item.name  + "\n";
		    }
 		    alert(str);
		} */







    function createAUIGridCust(){



        var columnLayout = [ {
            renderer : {
            type : "CheckBoxEditRenderer",
            showLabel : false, // 참, 거짓 텍스트 출력여부( 기본값 false )
            editable : false, // 체크박스 편집 활성화 여부(기본값 : false)
            checkValue : "1", // true, false 인 경우가 기본
            width : 30,
            unCheckValue : "0",
         // 체크박스 Visible 함수
            checkableFunction  : function(rowIndex, columnIndex, value, isChecked, item, dataField) {
                var assiinCd = fn_getCheckedRowItems(); //저장id

                var aa = new Date();
/*                 var year = aa.getFullYear();
                var month = aa.getMonth()+1; */

                if(item.c1 == 1){
                    AUIGrid.updateRow(myCustGridID, {
                          "codyId" : "",
                          "codyCd" : "",
                          "c1" : "0"
                        }, rowIndex);
                }else{
                    AUIGrid.updateRow(myCustGridID, {
                         "codyId" : assiinCd[0],      //저장용
                        "codyCd" : assiinCd[1],      //화면용
                        "c1" : "1" ,
                          "year" : "${ManuaMyBSMonth}",
/*                          "month" : month, */
                          "stus" : "1"
                      }, rowIndex);
                }
                return true;
            }
        }
        }, {
            dataField : "c1",
            headerText : "Customer",
            width : 120,
            visible:false
        }, {
            dataField : "name",
            headerText : "Customer",
            width : 200
        }, {
            dataField : "salesOrdId",
            headerText : "salesordid",
            width : 100,
            visible:false
        }, {
            dataField : "salesOrdNo",
            headerText : "Sales Order",
            editable : false,
            width : 110
        }, {
            dataField : "hsDate",
            headerText : "Hs Date",
            visible:false,
            width : 130
        }, {
            dataField : "codyId",
            headerText : "Cody id",
            editable : false,
            width : 140,
            visible:false
        }, {
            dataField : "codyCd",
            headerText : "Cody Code",
            editable : false,
            width : 140
        }, {
            dataField : "year",
            headerText : "year",
            width : 130  ,
            visible : false
        }, {
            dataField : "month",
            headerText : "month",
            visible : false,
            width : 130
        }, {
            dataField : "stus",
            headerText : "stusCodeId",
            visible : false,
            width : 130
           }];
        // 그리드 속성 설정
        var gridPros = {
            // 페이징 사용
            usePaging : true,
            // 한 화면에 출력되는 행 개수 20(기본값:20)
            pageRowCount : 20,

            editable : true,

            //showStateColumn : true,

            displayTreeOpen : true,

            headerHeight : 30,

            // 읽기 전용 셀에 대해 키보드 선택이 건너 뛸지 여부
            skipReadonlyColumns : true,

            // 칼럼 끝에서 오른쪽 이동 시 다음 행, 처음 칼럼으로 이동할지 여부
            wrapSelectionMove : true,

            // 줄번호 칼럼 렌더러 출력
            showRowNumColumn : true

            // 체크박스 표시 설정
            //showRowCheckColumn : true,
            // 전체 체크박스 표시 설정
            //showRowAllCheckBox : true
        };

        myCustGridID = AUIGrid.create("#grid_wrapCust", columnLayout, gridPros);

    }

    function createAUIGridCd(){
        // AUIGrid 칼럼 설정
        var columnLayout = [ {
                    dataField : "codyId",
                    headerText : "Cody Code",
                    width : 120
           }, {
		            dataField : "codyName",
		            headerText : "Cody Name",
		            width : 220
           }, {
                    dataField : "stus",
                    headerText : "stus",
                    width : 120,
                     visible:false
           }, {
                    dataField : "rnum",
                    headerText : "stus111",
                    width : 120,
                     visible:false
            }];

            // 그리드 속성 설정
            var gridPros = {
                // 페이징 사용
                //usePaging : true,
                // 한 화면에 출력되는 행 개수 20(기본값:20)
                //pageRowCount : 20,

                editable : true,

                //showStateColumn : true,

                displayTreeOpen : true,

                headerHeight : 30,

                // 읽기 전용 셀에 대해 키보드 선택이 건너 뛸지 여부
                skipReadonlyColumns : true,

                // 칼럼 끝에서 오른쪽 이동 시 다음 행, 처음 칼럼으로 이동할지 여부
                wrapSelectionMove : true,

                // 줄번호 칼럼 렌더러 출력
                showRowNumColumn : true,

                // 체크박스 대신 라디오버튼 출력함
                showRowCheckColumn : true,

			    //showStateColumn : true,

			    rowCheckToRadio : true


/*                 // 체크박스 표시 설정
                showRowCheckColumn : true,
                // 전체 체크박스 표시 설정
                showRowAllCheckBox : true */

            };
                    //myGridID = GridCommon.createAUIGrid("grid_wrap", columnLayout, gridPros);
                myCdGridID = AUIGrid.create("#grid_wrapCd", columnLayout, gridPros);

                    // 체크박스 클린 이벤트 바인딩
			    AUIGrid.bind(myCdGridID, "rowCheckClick", function( event ) {
			 		        //alert("rowIndex : " + event.rowIndex + ", id : " + event.item.id + ", name : " + event.item.name + ", checked : " + event.checked);
					        getEditedRowItems();
					    });

    }




			function setCheckedRowsByIds(){

			    var columnCount =  AUIGrid.getRowCount(myCdGridID);

                if(columnCount > 0 ){
                      var items = ['0'];
                        AUIGrid.setCheckedRowsByValue(myCdGridID, "rnum" ,  ["1"]);
//                        AUIGrid.setCheckedRowsByValue(myGridID.pid,"CHK", ["A"]);
                 }

			} // 시작 시 체크된 상태로 표시



/*                          "codyId" : assiinCd[0],      //저장용
                        "codyCd" : assiinCd[1],      //화면용
 */

		// 수정된 행들 얻기
		function getEditedRowItems() {
		    // 수정된 행 아이템들(배열)
		    var editedRowItems = AUIGrid.getEditedRowItems(myCustGridID);
		    var str ="";


		    for(var i=0, len=editedRowItems.length; i<len; i++) {
		          editedRowItems[i]["codyCd"] = "";
                str += editedRowItems[i]["codyCd"] +"\n";
		    }
//		      alert(str);
		}



        // 체크된 아이템 얻기
    function fn_getCheckedCdRowItems() {
            var checkedItems = AUIGrid.getCheckedRowItems(myCustGridID);
            var str = "";
            var rowItem;
            var len = checkedItems.length;

            if(len <= 0) {
/*                 alert("체크된 행 없음!!"+len); */
                return;
            }

            for(var i=0; i<len; i++) {
                rowItem = checkedItems[i];
                str += "row : " + rowItem.rowIndex + ", id :" + rowItem.item.id + ", name : " + rowItem.item.name  + "\n";
            }
/*           alert(str); */
        }


    function fn_getselectPopUpListAjax(){
       // Common.ajax("GET", "/services/bs/selectPopUpCdList.do", {SaleOrdList : '${ordCdList}',BrnchCdList : '${brnchCdList}'}, function(result) {


    	   Common.ajax("GET",
        			"/services/bs/selectPopUpCdList.do",
        			{SaleOrdList : '${ordCdList}',SalesOrderNo : '${SalesOrderNo}',assignCody:$('#assignCody').val()},
        			function(result) {
        	               console.log("성공.");
	                       console.log("data : " + result);

                           AUIGrid.setGridData(myCdGridID, result);

                           //setCheckedRowsByIds();
	                }
            );

	     // Common.ajax("GET", "/services/bs/selectPopUpCustList.do", {SaleOrdList : '${ordCdList}',BrnchCdList : '${brnchCdList}', ManuaMyBSMonth:'${ManuaMyBSMonth}'}, function(result) {
	    	 Common.ajax("GET", "/services/bs/selectPopUpCustList.do", {SaleOrdList : '${ordCdList}',SalesOrderNo : '${SalesOrderNo}', ManuaMyBSMonth:'${ManuaMyBSMonth}'}, function(result) {
	         console.log("성공.");
	         console.log("data : " + result);

	         AUIGrid.setGridData(myCustGridID, result);
	     });


    }

    function fn_searchCody(){

            Common.ajax("GET",
                     "/services/bs/selectPopUpCdList.do",
                     {SaleOrdList : '${ordCdList}',SalesOrderNo : '${SalesOrderNo}',assignCody:$('#assignCody').val()},
                     function(result) {
                            AUIGrid.setGridData(myCdGridID, result);
            });
     }



     function fn_codyChange(){

            if($("#_openGb").val() == "codyChange"){

                //$('#grid_wrapCust') .attr("editable", true);
                //$("#grid_wrapCust").removeAttr("disabled");
            }

    }








     function fn_codyAssignSave(){
            var jsonObj =  GridCommon.getEditData(myCustGridID);
                 jsonObj.form = $("#searchFormPop").serializeJSON();

                Common.ajax("POST", "/services/bs/hsOrderSave.do",  jsonObj , function(result) {

                	  var checkedItems = AUIGrid.getCellValue(myCustGridID, 0, "codyCd");;
                      if(checkedItems == null || checkedItems == "") {
                          Common.alert("Please select Cody Code when Create HS Order.");
                            return;
                      }else{
                Common.alert(result.message, fn_parentReload);
                }
        });

    }



    function fn_parentReload() {
        fn_getBSListAjax(); //parent Method (Reload)
    }



    $(document).ready(function() {

/*        if($("#_openGb").val() != "codyChange"){
           $("#btnCreate").hide();
           //$('#grid_wrapCust') .attr("disabled", true);

        }else{
            $("#btnSave").hide();
            //$('#grid_wrapCust') .attr("disabled", true);
        } */


        createAUIGridCd();
        createAUIGridCust();


        fn_getselectPopUpListAjax();
//        setCheckedRowsByIds();

/*          var checkedItems = AUIGrid.getCheckedRowItemsAll(myCustGridID);
         if(checkedItems.length >= 0) {
             alert("aaaa");
         } */




    });



    </script>


<form action="#" method="post" id="searchFormPop">

    <!-- <input type="hidden" name="manuaMyBSMonth"  id="_manuaMyBSMonth"/>  --> <!-- schdulId  -->
  <!-- schdulId  -->

<div id="popup_wrap" class="popup_wrap"><!-- popup_wrap start -->

<header class="pop_header"><!-- pop_header start -->
<h1>HS Order Create</h1>
<ul class="right_opt">
    <!-- <li><p class="btn_blue2"><a href="javascript:fn_codyChange();" id="btnCodyCh" name="btnCodyCh">Assign Cody Change</a></p></li> -->
    <li><p class="btn_blue2"><a href="javascript:fn_codyAssignSave();" id="btnCreate" id="btnCreate" >Create</a></p></li>
    <li><p class="btn_blue2"><a href="#" id="_close1">Close</a></p></li>
</ul>

</header><!-- pop_header end -->

<section class="pop_body"><!-- pop_body start -->

<div class="divine_auto"><!-- divine_auto start -->

<div style="width: 400px;">

<aside class="title_line"><!-- title_line start -->
<h2>Cody List</h2>
<ul class="right_btns">
    <li><p class="btn_blue"><a href="#" onclick="javascript:fn_searchCody();"><span class="search"></span>
       <spring:message code='sys.btn.search' /></a></p></li>
    </ul>
</aside><!-- title_line end -->

<!-- <section class="search_result"> -->
<!--     <aside class="title_line mt30">title_line start -->
<!--     <ul class="right_btns"> -->
<!--     <li><p class="btn_blue"><a href="#" onclick="javascript:fn_searchCody();"><span class="search"></span> -->
<%--        <spring:message code='sys.btn.search' /></a></p></li> --%>
<!--     </ul> -->
<!--     </aside> -->
<!--  </section> -->

<table id="assignCodyTable" class="type1" ><!-- table start -->
<tbody>
<tr>
    <th scope="row">Search Cody:</th>
    <td><input id="assignCody" name="assignCody" type="text" title="assignCody"  class="w100p" /></td>
</tr>
</tbody>
</table><!-- table end -->

<div class="border_box" style="height:400px"><!-- border_box start -->

    <input type="hidden" name="ManuaMyBSMonth"  id="ManuaMyBSMonth" value="${ManuaMyBSMonth}"/>

<ul class="right_btns">
<!--     <li><p class="btn_grid"><a href="#">EDIT</a></p></li>
    <li><p class="btn_grid"><a href="#">NEW</a></p></li> -->
</ul>

<article class="grid_wrapCd"><!-- grid_wrap start -->
<div id="grid_wrapCd" style="width: 100%; height: 334px; margin: 0 auto;"></div>
</article><!-- grid_wrap end -->

</div><!-- border_box end -->

</div>

<div style="width:50%;">

<aside class="title_line"><!-- title_line start -->
<h2>HS Order List</h2>
</aside><!-- title_line end -->

<div class="border_box" style="height:400px; width: 550px"><!-- border_box start -->

<ul class="right_btns">
<!--     <li><p class="btn_grid"><a href="#">EDIT</a></p></li>
    <li><p class="btn_grid"><a href="#">NEW</a></p></li> -->
</ul>

<article class="grid_wrapCust"><!-- grid_wrap start -->
      <div id="grid_wrapCust" style="width: 530px; height: 334px; margin: 0 auto;"></div>
</article><!-- grid_wrap end -->

<ul class="center_btns">
<!--     <li><p class="btn_blue2"><a href="#">Assign Cody Change</a></p></li>
    <li><p class="btn_blue2"><a href="#">Cody Assign</a></p></li>
    <li><p class="btn_blue2"><a href="#">HS Transfer</a></p></li> -->
</ul>

</div><!-- border_box end -->

</div>

<div style="width:30%;">

<!-- <aside class="title_line">title_line start
<h2>Cody – HS Order</h2>
</aside>title_line end

<div class="border_box" style="height:400px">border_box start

<ul class="right_btns">
    <li><p class="btn_grid"><a href="#">EDIT</a></p></li>
    <li><p class="btn_grid"><a href="#">NEW</a></p></li>
</ul>

<article class="grid_wrapCd-1">grid_wrap start
<div id="grid_wrapCd-1" style="width: 100%; height: 334px; margin: 0 auto;"></div>
</article>grid_wrap end -->



</div><!-- border_box end -->

</div>

</div><!-- divine_auto end -->

</section><!-- pop_body end -->

</div><!-- popup_wrap end -->
</form>
</body>
</html>