<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c"      uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="form"   uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="ui"     uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>


    <script type="text/javaScript" language="javascript">

	    // AUIGrid 생성 후 반환 ID
	    var myGridID;
	    var gridValue;
    
        var option = {
                width : "1000px", // 창 가로 크기
                height : "600px" // 창 세로 크기
            };
    
    
    
        function fn_close(){
            window.close();
        }
        
        
        function createAUIGrid(){
		        // AUIGrid 칼럼 설정
		        var columnLayout = [ {
/* 					          dataField : "checkFlag",
					          headerText : '<input type="checkbox" id="allCheckbox" name="allCheckbox" style="width:15px;height:15px;">',
					          width : "3%",
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
                                      
                        }, {		         */
                            dataField:"rnum",
                            headerText:"RowNum",
                            width:120,
                            height:30
                            //,
                            //visible:false
                              }, {                        
                            dataField : "custId",
                            headerText : "Customer",
                            width : 120
                        }, {
                            dataField : "name",
                            headerText : "Customer Name",
                            width : 120                            
                       }, {
                            dataField : "salesOrdNo",
                            headerText : "Sales Order",
                            width : 120
                        }, {
                            dataField : "hsDate",
                            headerText : "HS Date",
                            width : 120
                        }, {                        
		                    dataField : "no",
		                    headerText : "HS Order",
		                    width : 120
                        }, {
                            dataField : "codyId",
                            headerText : "Assign Cody",
                            width : 120		         
                        }, {
                            dataField : "stusCodeId",
                            headerText : "Cody Status",
                            width : 120
                        }, {
                            dataField : "month",
                            headerText : "Availability",
                            width : 120             
                        }, {
                            dataField : "month",
                            headerText : "Complete Cody",
                            width : 120
                        }, {
                            dataField : "brnchId",
                            headerText : "Branch",
                            width : 120                                                                                  
		            }];
		            // 그리드 속성 설정
		            var gridPros = {
		                // 페이징 사용       
		                usePaging : true,
		                // 한 화면에 출력되는 행 개수 20(기본값:20)
		                pageRowCount : 20,
		                
		                editable : true,
		                
		                showStateColumn : true, 
		                
		                displayTreeOpen : true,
		                
		                
		                headerHeight : 30,
		                
		                // 읽기 전용 셀에 대해 키보드 선택이 건너 뛸지 여부
		                skipReadonlyColumns : true,
		                
		                // 칼럼 끝에서 오른쪽 이동 시 다음 행, 처음 칼럼으로 이동할지 여부
		                wrapSelectionMove : true,
		                
		                // 줄번호 칼럼 렌더러 출력
		                showRowNumColumn : true,

				        // 체크박스 표시 설정
				        showRowCheckColumn : true,
				        // 전체 체크박스 표시 설정
				        showRowAllCheckBox : true
		        
		            };
		                    //myGridID = GridCommon.createAUIGrid("grid_wrap", columnLayout, gridPros);
		                myGridID = AUIGrid.create("#grid_wrap", columnLayout, gridPros);
		    }
    
    
    
		//전체 체크/해제 하기
		var allChecked = false;
		function setAllCheckedRows() {
		    allChecked = !allChecked;
		    AUIGrid.setAllCheckedRows(myGridID, allChecked);
		};

    
    
         // 리스트 조회.
        function fn_getBSListAjax() {        
        
                var radioVal = $("input:radio[name='searchDivCd']:checked").val();                           
            
	            if (radioVal == 1 ){ //hs_no  Create before
			            Common.ajax("GET", "/bs/selectHsAssiinlList.do", $("#searchForm").serialize(), function(result) {
			                
			                console.log("성공.");
			                console.log("data : " + result);
			                AUIGrid.setGridData(myGridID, result);
		                 });
	            }else {//hs_no  Create after
	            
		                Common.ajax("GET", "/bs/selectHsManualList.do", {ManuaSalesOrder:$("#ManuaSalesOrder").val(),ManuaMyBSMonth:$("#ManuaMyBSMonth").val(),ManualCustomer:$("#manualCustomer").val()}, function(result) {
		                    
		                    console.log("성공.");
		                    console.log("data : " + result);
		                    AUIGrid.setGridData(myGridID, result);
			            });
	            }
     
          }
        
/*         function fn_getHSConfAjax {
            Common.popupDiv("/bs/selectHSConfigPop.do?isPop=true&BrnchId=" + AUIGrid.getCellValue(myGridID, event.rowIndex, "brnchId"), "");
            
//            Common.popupDiv("/organization/selectMemberListDetailPop.do?isPop=true&MemberID=" + AUIGrid.getCellValue(myGridID, event.rowIndex, "memberid")+"&MemberType=" + AUIGrid.getCellValue(myGridID, event.rowIndex, "membertype"), "");            

        } */
        
        
        
        

		
/*          // 체크박스 클릭 이벤트 바인딩
	    AUIGrid.bind(myGridID, "rowCheckClick", function( event ) {
            brnchId =  AUIGrid.getCellValue(myGridID, event.rowIndex, "brnchId");
            custId = AUIGrid.getCellValue(myGridID, event.rowIndex, "custId");
            
            alert("brnchId : " + brnchId  + ", custId : " + custId);

	    }); */
	    
	    



		$(function(){
	       $("#hSConfiguration").click(function(){
	        var checkedItems = AUIGrid.getCheckedRowItemsAll(myGridID);
	        
	        if(checkedItems.length <= 0) {
	            Common.alert('No data selected.');
	            return false;
	        }else{
	           /*  for (var i = 0 ; i < checkedItems.length ; i++){
	                if(checkedItems[i].grcmplt == 'Y'){
	                    Common.alert('Already processed.');
	                    return false;
	                    break;
	                }
	            } */
	            
                var str = "";
                var custStr = "";
			    var rowItem;
			    var brnchId = "";
			    var saleOrdList = "";
			    var list = "";
			    
			    //var saleOrdList = [];
			    var saleOrd = {
			         salesOrdNo : ""
			    };
			    
			    //AUIGrid.setGridData( myCustGridID,  GridCommon.getGridData(myGridID));
			    
			    
			    
			    //var objList = {};
			    //saleOrdList += "[";
			    //saleOrdList += "(";
			    
			    for(var i=0, len = checkedItems.length; i<len; i++) {
			        rowItem = checkedItems[i];
			        //str += "hsOrder : " + rowItem.no + ", salesOrdNo :" + rowItem.item.salesOrdNo + ", codyId : " + rowItem.item.codyId  + "\n";
			        //str += "inGb : " + $("input:radio[name='searchDivCd']:checked").val() + " , hsOrder : " + rowItem.no +" , salesOrdNo :" + rowItem.salesOrdNo + ", codyId : " + rowItem.codyId +" , custId : " + rowItem.custId +" , brnchId : " + rowItem.brnchId  +"\n";
			        
			        //str += "custId : " + rowItem.custId + ", salesOrdNo :" + rowItem.salesOrdNo + ", brnchId : " + rowItem.brnchId  +"\n";
			        //saleOrdList += "salesOrdNo = " + rowItem.salesOrdNo +"\n";
                    //saleOrdList +=  rowItem.salesOrdNo +"\n";
			        //saleOrdList += "{"salesOrdNo"="+rowItem.salesOrdNo+"};
			        //saleOrdList += "{\"salesOrdNo\"=\""+rowItem.salesOrdNo+"\"}";
			        saleOrdList += rowItem.salesOrdNo;
			        
			        //saleOrd.salesOrdNo = rowItem.salesOrdNo;
                    
                    if(i  != len -1){
                        saleOrdList += ",";
                    }

                    
                    if(i==0){
                         brnchId = rowItem.brnchId;
                    }
			        
			       /*  var obj += AUIGrid.getItemByRowIndex(myGridID,event.rowIndex);
                    objList.add = obj;
                     */
			        
			        //saleOrdList.push(saleOrd);
			    }
			    
			    //saleOrdList += "]";
			    //saleOrdList += ")";
			    
			    //alert("brnchId:::"+brnchId);
			    //alert(saleOrdList);
			    
			    // var aa = $.parseJSON(saleOrdList);
/* 			     var aa = (saleOrdList);
                alert("aa.lengh : " + aa.length);
                alert("aa.salesOrdNo : " + aa[0].salesOrdNo);
 */
 	
 	            var jsonObj = {
	                     "SaleOrdList" : saleOrdList,
	                     "BrnchId": brnchId,
	                     "ManualCustId" : $("#manualCustomer").val(),
	                     "ManuaMyBSMonth" : $("#ManuaMyBSMonth").val()
	            };

	            
//		        var jsonObj  = str;    
		        
                  //Common.popupDiv("/bs/selectHSConfigListPop.do",jsonObj);
                  
                  
                  
                  Common.popupDiv("/bs/selectHSConfigListPop.do?isPop=true&JsonObj="+jsonObj+"&CheckedItems="+saleOrdList+"&BrnchId="+brnchId    ); 
                //Common.popupDiv("/bs/selectHSConfigListPop.do?isPop=true&custId=" + 31258 ,"");
/*                 Common.popupDiv("/bs/selectHSConfigListPop.do?isPop=true", jsonObj, function(params) {
                }); */
                
                //Common.popupDiv("/bs/selectHSConfigListPop.do?isPop=true&BrnchId=" + AUIGrid.getCellValue(myGridID, event.rowIndex, "brnchId"), "");
                //Common.popupDiv("/bs/selectHSConfigListPop.do?isPop=true&BrnchId=" + AUIGrid.getCellValue(myGridID, event.rowIndex, "brnchId")+"&CustId=" + AUIGrid.getCellValue(myGridID, event.rowIndex, "custId"), "");	
                            
	        }
	        
	    });
	});

    
    
/* 		     AUIGrid.bind(myGridID, "cellClick", function(event) {
		        custId =  AUIGrid.getCellValue(myGridID, event.rowIndex, "custId");
		    });  */
		    
    
        //Start AUIGrid
        $(document).ready(function() {
                 $('#myBSMonth').val($.datepicker.formatDate('mm/yy', new Date()));
                 $('#ManuaMyBSMonth').val($.datepicker.formatDate('mm/yy', new Date()));
                 
                // AUIGrid 그리드를 생성합니다.
		        createAUIGrid();
                AUIGrid.setSelectionMode(myGridID, "singleRow");


	            
/*            $('#cmdBranchCode').change(function (){
                 var cmdBranchVal = $('#cmdBranchCode').val();
                 
                 if(cmdBranchVal != null && cmdBranchVal.length != 0  ){
                    doGetCombo('/bs/getCdUpMemList.do', $(this).val() , ''   , 'cmdCdManager' , 'S', '');
                 }else {
                    getSelectClear('#cmdCdManager');
                 }
                
            }); */

 /*           $('#cmdCdManager').change(function (){
                 alert("22222222222::::" + $('#cmdCdManager').val());
                doGetCombo('/bs/getCdList.do', $(this).val() , ''   , 'cmdcodyCode' , 'S', '');
            });
  */           
            
         $("#cmdBranchCode").change(function() {
            $("#cmdCdManager").find('option').each(function() {
                $(this).remove();
            });
             $("#cmdcodyCode").find('option').each(function() {
                $(this).remove();
            });
            
            if ($(this).val().trim() == "") {
                return;
            }       
            doGetCombo('/bs/getCdUpMemList.do', $(this).val() , ''   , 'cmdCdManager' , 'S', '');
        });    

                            

	         $("#cmdCdManager").change(function() {
	            $("#cmdcodyCode").find('option').each(function() {
	                $(this).remove();
	            });
	            if ($(this).val().trim() == "") {
	                return;
	            }       
	           doGetCombo('/bs/getCdList.do', $(this).val() , ''   , 'cmdcodyCode' , 'S', '');
	        });   
        
                
                fn_checkRadioButton();
        
        });
    
    function fn_checkRadioButton(objName){

		if( document.searchForm.elements['searchDivCd'][0].checked == true ) {
		              
                    var divhsManuaObj = document.querySelector("#hsManua");
                    divhsManuaObj.style.visibility="hidden";

                    var divhsManagementObj = document.querySelector("#hsManagement");
                    divhsManagementObj.style.visibility="visible";
		}else{
		
		            var divhsManagementObj = document.querySelector("#hsManagement");
                    divhsManagementObj.style.visibility="hidden";
                    
                    var divhsManuaObj = document.querySelector("#hsManua");
                    divhsManuaObj.style.visibility="visible";
		}
    }
    
    
    </script>


<form id="searchForm" name="searchForm">    


<section id="content"><!-- content start -->
<ul class="path">
    <li><img src="../images/common/path_home.gif" alt="Home" /></li>
    <li>Sales</li>
    <li>Order list</li>
</ul>

<aside class="title_line"><!-- title_line start -->
<p class="fav"><a href="#" class="click_add_on">My menu</a></p>
<h2>HS Management</h2>
<!--조회조건 추가  -->
    <label><input type="radio" name="searchDivCd" value="1" onClick="fn_checkRadioButton('comm_stat_flag')" checked />HS Management</label>
    <label><input type="radio" name="searchDivCd" value="2" onClick="fn_checkRadioButton('comm_stat_flag')" />HS Manual</label>
</aside><!-- title_line end -->


<div id="hsManagement" style="display:block;">
<form  id="hsManagement" method="post">

			<section class="search_table"><!-- search_table start -->
			<form action="#" method="post">
			
			<table class="type1"><!-- table start -->
			<caption>table</caption>
			<colgroup>
			    <col style="width:100px" />
			    <col style="width:*" />
			    <col style="width:100px" />
			    <col style="width:*" />
			</colgroup>
			<tbody>
			<tr>
			    <th scope="row">Cody Branch</th>
			    <td>
			    <select id="cmdBranchCode" name="cmdBranchCode" class="w100p">
			           <option value="">branchCode</option>
			           <c:forEach var="list" items="${branchList }" varStatus="status">
			           <option value="${list.codeId}">${list.codeName}</option>
			           </c:forEach>
			    </select>
			    </td>
			    <th scope="row">Cody Manager</th>
			    <td>
			        <select id="cmdCdManager" name="cmdCdManager" class="w100p">
			    </td>
			        <th scope="row">Cody</th>
			    <td>
			        <select id="cmdcodyCode" name="cmdcodyCode" class="w100p">
			        <option value="">cody</option>
			    </td>
			</tr>
			<tr>
			    <th scope="row">HS Order</th>
			    <td>
			        <input id="txtHsOrderNo" name="txtHsOrderNo"  type="text" title="" placeholder="HS Order" class="w100p" />
			    </td>
			    <th scope="row">HS Period</th>
			    <td>
			        <input id="myBSMonth" name="myBSMonth" type="text" title="기준년월" placeholder="MM/YYYY" class="j_date2 w100p" readonly />
			    </td>
			    <th scope="row">Customer</th>
			    <td>
			        <input id="txtCustomer" name="txtCustomer"  type="text" title="" placeholder="Customer" class="w100p" />
			    </td>
			    
			</tr>
			<tr>
			    <th scope="row">Sales Order</th>
			    <td>
			        <input id="txtSalesOrder" name="txtSalesOrder"  type="text" title="" placeholder="Sales Order" class="w100p" />
			    </td>
			    <th scope="row">Install Month</th>
			    <td>
			        <input id="myInstallMonth" name="myInstallMonth" type="text" title="기준년월" placeholder="MM/YYYY" class="j_date2 w100p" readonly />
			    </td>
			</tr>
			
			</tbody>
			</table><!-- table end -->
			
			<aside class="link_btns_wrap"><!-- link_btns_wrap start -->
			<p class="show_btn"><a href="#"><img src="../images/common/btn_link.gif" alt="link show" /></a></p>
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
			    <p class="hide_btn"><a href="#"><img src="../images/common/btn_link_close.gif" alt="hide" /></a></p>
			    </dd>
			</dl>
			</aside><!-- link_btns_wrap end -->
			
			</form>
			</section><!-- search_table end -->
</form>
</div>



<div id="hsManua" style="display:block;">
<form  id="hsManua" method="post">

            <section class="search_table"><!-- search_table start -->
            <form action="#" method="post">
            
            <table class="type1"><!-- table start -->
            <caption>table</caption>
            <colgroup>
                <col style="width:100px" />
                <col style="width:*" />
                <col style="width:100px" />
                <col style="width:*" />
            </colgroup>
            <tbody>
            <tr>
                <th scope="row">Sales Order</th>
                <td>
                    <input id="ManuaSalesOrder" name="ManuaSalesOrder"  type="text" title="" placeholder="Sales Order" class="w100p" />
                </td>
                <th scope="row">HS Period</th>
                <td>
                    <input id="ManuaMyBSMonth" name="ManuaMyBSMonth" type="text" title="기준년월" placeholder="MM/YYYY" class="j_date2 w100p" readonly />
                </td>
                <th scope="row">Customer</th>
                <td>
                    <input id="manualCustomer" name="manualCustomer"  type="text" title="" placeholder="Customer" class="w100p" />
                </td>
                
            </tr>
            </tbody>
            </table><!-- table end -->
            
            <aside class="link_btns_wrap"><!-- link_btns_wrap start -->
            <p class="show_btn"><a href="#"><img src="../images/common/btn_link.gif" alt="link show" /></a></p>
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
                <p class="hide_btn"><a href="#"><img src="../images/common/btn_link_close.gif" alt="hide" /></a></p>
                </dd>
            </dl>
            </aside><!-- link_btns_wrap end -->
            
            </form>
            </section><!-- search_table end -->
</form>
</div>


<section class="search_result"><!-- search_result start -->

<ul class="right_btns">
    <li><p class="btn_grid"><a href="#" " onclick="javascript:fn_getBSListAjax();">Search</a></p></li>
    <li><p class="btn_grid"><a id="hSConfiguration"><span class="search"></span>HS Configuration</a></p></li>
</ul>
<!-- <ul class="right_btns">
    <li><p class="btn_grid"><a href="#" " onclick="javascript:fn_getHSConfAjax();">HS Configuration</a></p></li>
</ul> -->
<article class="grid_wrap"><!-- grid_wrap start -->
그리드 영역
    <div id="grid_wrap" style="width: 100%; height: 334px; margin: 0 auto;"></div>
</article><!-- grid_wrap end -->

</section><!-- search_result end -->

<ul class="center_btns">
<!--     <li><p class="btn_blue2"><a href="#">Cody Assign</a></p></li> -->
</ul>

</section><!-- content end -->
</form>



    <div class="popup_wrap" id="confiopenwindow" style="display:none"><!-- popup_wrap start -->
        <header class="pop_header"><!-- pop_header start -->
	        <section id="content"><!-- content start -->
	        <ul class="path">
	            <li><img src="../images/common/path_home.gif" alt="Home" /></li>
	            <li><p class="btn_blue2"><a href="#">CLOSE</a></p></li>
	        </ul>
         </header><!-- pop_header end -->
        <aside class="title_line"><!-- title_line start -->
        <p class="fav"><a href="#" class="click_add_on">My menu</a></p>
        <h2>BS Management</h2>
        </aside><!-- title_line end -->
        
        <div class="divine_auto"><!-- divine_auto start -->
        
        <div style="width:20%;">
        
        <aside class="title_line"><!-- title_line start -->
        <h3>Cody List</h3>
        </aside><!-- title_line end -->
        
        <div class="border_box" style="height:400px"><!-- border_box start -->
        
        <ul class="right_btns">
<!--             <li><p class="btn_grid"><a href="#">EDIT</a></p></li>
            <li><p class="btn_grid"><a href="#">NEW</a></p></li> -->
        </ul>
        
        <article class="grid_wrap"><!-- grid_wrap start -->
        그리드 영역
        </article><!-- grid_wrap end -->
        
        </div><!-- border_box end -->
        
        </div>
        
        <div style="width:50%;">
        
        <aside class="title_line"><!-- title_line start -->
        <h3>HS Order List</h3>
        </aside><!-- title_line end -->
        
        <div class="border_box" style="height:400px"><!-- border_box start -->
        
        <ul class="right_btns">
<!--             <li><p class="btn_grid"><a href="#">EDIT</a></p></li>
            <li><p class="btn_grid"><a href="#">NEW</a></p></li> -->
        </ul>
        
        <article class="grid_wrap"><!-- grid_wrap start -->
        그리드 영역
        </article><!-- grid_wrap end -->
        
        <ul class="center_btns">
<!--             <li><p class="btn_blue2"><a href="#">Assign Cody Change</a></p></li>
            <li><p class="btn_blue2"><a href="#">Cody Assign</a></p></li>
            <li><p class="btn_blue2"><a href="#">HS Transfer</a></p></li> -->
        </ul>
        
        </div><!-- border_box end -->
        
        </div>
        
        <div style="width:30%;">
        
        <aside class="title_line"><!-- title_line start -->
        <h3>Cody – HS Order</h3>
        </aside><!-- title_line end -->
        
        <div class="border_box" style="height:400px"><!-- border_box start -->
        
        <ul class="right_btns">
<!--             <li><p class="btn_grid"><a href="#">EDIT</a></p></li>
            <li><p class="btn_grid"><a href="#">NEW</a></p></li> -->
        </ul>
        
        <article class="grid_wrap"><!-- grid_wrap start -->
        그리드 영역
        </article><!-- grid_wrap end -->
        
        <ul class="center_btns">
            <li><p class="btn_blue2"><a href="#">Confirm</a></p></li>
        </ul>
        
        </div><!-- border_box end -->
        
        </div>
        
        </div><!-- divine_auto end -->
        
        </section><!-- content end -->    
    </div>