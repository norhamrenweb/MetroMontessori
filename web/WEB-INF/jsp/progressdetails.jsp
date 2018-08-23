<%-- 
    Document   : progressdetails
    Created on : 06-abr-2017, 10:18:54
    Author     : Jesus
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@taglib prefix="spring" uri="http://www.springframework.org/tags"%>

<!DOCTYPE html>
<html>
    <%@ include file="infouser.jsp" %>
    <head>
        <title>Progress Details</title>
        <script>
           $(document).ready(function(){
               var numberAttempted = $('#contenedorAttempted').children().length;
               $("#showAttempteds").html(numberAttempted+'<br><span class="glyphicon glyphicon-triangle-bottom"></span>');
               
                $('#tablelessons').DataTable();
                
                $("#contenedorAttempted").on("hide.bs.collapse", function(){
                    $("#showAttempteds").html(numberAttempted+'<br><span class="glyphicon glyphicon-triangle-bottom"></span>');
                });
                $("#contenedorAttempted").on("show.bs.collapse", function(){
                  $("#showAttempteds").html(numberAttempted+'<br><span class="glyphicon glyphicon-triangle-top"></span>');
                });
                var message = '${message}';
    
     if (message === 'Student does not have progress under the selected objective' ){
     $('#myModal').modal({
        show: 'false'
    });
     };

            });
        </script>
        <style>
            .attempted{
                color: #D0D2D3;
            }
             .containerProgress
            {
                display: table;
/*                background-color: #d9edf7;*/
                min-height: 200px;
            }
            .cellProgress
            {
                display: table-cell;
                vertical-align: middle;
                padding: 10px;
                
            }
            .spacediv
            {
                margin-top: 10px;
                margin-bottom: 10px;
            }
            .mastered
            {
                display: table;
                width: 50%;
                min-height: 100px;
                border-radius: 10px;
                background-color: #08c;
                color: #000000 !important;
                font-size: xx-large;
                font-weight: bold;
            }
            #showAttempteds
            {
                background-color: transparent;
                border-width: 0px;
                border-style: none;
                border-color: transparent;
                border-image: initial;
            }
            @media print{
                
                .noPrint{
                    display: none;
                }
                .dataTables_filter, .dataTables_length, .dataTables_info, .dataTables_paginate{
                    display: none;
                }
                .mastered
                {
                    display: table;
                    width: 50%;
                    min-height: 100px;
                    border-radius: 10px;
                    background-color: #08c !important;
                    color: #000000 !important;
                    font-size: xx-large;
                    font-weight: bold;
                }
                
            }
            
        </style>
    </head>
    <body>
        <div class="container">
            <div class="col-xs-12 text-center">
                <h2>${studentname}</h2>
            </div>
            
            <div class="col-xs-12" style="border-bottom: #08c solid 1px">
                <div class="col-xs-4">Level</div>
                <div class="col-xs-4">Subject</div>
                <div class="col-xs-4">Objective</div>
            </div>
            <div class="col-xs-12">
                <div class="col-xs-4">${gradelevel}</div>
                <div class="col-xs-4">${subject}</div>
                <div class="col-xs-4">${objective}</div>
            </div>
            
            <div class="col-xs-6" style="margin-top: 30px;">
                <div class="col-xs-12 spacediv">
                    <div class="col-xs-6">Presented</div><div class="col-xs-6">${presenteddate}</div>
                </div>
                <div class="col-xs-12 spacediv">
                    <div class="col-xs-6">Attempted</div><div class="col-xs-6">${attempteddate}
                    <button class="" data-toggle="collapse" data-target="#contenedorAttempted" id="showAttempteds">
                        
                    </button>
                    </div>    
                </div>
                <div class="col-xs-12 collapse " id="contenedorAttempted">
                    <c:forEach var="date" items="${attempteddates}">
                    <div class="col-xs-12 attempted">
                        <div class="col-xs-6">Attempted</div>
                        <div class="col-xs-6">${date}</div>
                    </div>
                    </c:forEach>
<!--                    <div class="col-xs-12 attempted">
                        <div class="col-xs-6">Attempted 2</div>
                        <div class="col-xs-6">21/04/2017</div>
                    </div>
                    <div class="col-xs-12 attempted">
                        <div class="col-xs-6">Attempted 3</div>
                        <div class="col-xs-6">22/04/2017</div>
                    </div>-->
                </div>    
                <div class="col-xs-12 spacediv">
                    <div class="col-xs-6">Mastered</div><div class="col-xs-6">${mastereddate}</div>
                </div>
            </div>
            <div class="col-xs-6 center-block">
                <div class="col-xs-6 col-xs-offset-3 containerProgress">
                    <div class="cellProgress">
                        <div class="mastered">
                            <div class="cellProgress text-center">${finalrating}</div>
                        </div>
                    </div>
                </div>
            </div>
            <div class="col-xs-12 spacediv" id="divTableLessons">
                <table id="tablelessons" class="display">
                    <thead>
                        <tr>
                            <th>Rating</th>
                            <th>Date</th>
                            <th>Comment</th>
                            <th>Presentation Name</th>
                            <th>Created By</th>
                        </tr>
                    </thead> 
                    
                    <c:forEach var="p" items="${progress}" >
                        <tr>
                            <td>${p.rating}</td>
                            <td>${p.comment_date}</td>
                            <td>${p.comment}</td>
                             <td>${p.lesson_name}</td>
                             <td>${p.createdby}</td>
                        </tr>
                    </c:forEach>
                    

                </table>

            </div>
            <div class="col-xs-12 text-center" >
                <input type="submit" value="Print Report" onClick="window.print()" class="btn btn-info noPrint"/> 
            </div>
        </div>
<div class="modal fade" id="myModal" tabindex="-1" role="dialog" aria-labelledby="myModalLabel">
 <div class="modal-dialog" role="document">
   <div class="modal-content">
     <div class="modal-header">
       <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
<!--        <h4 class="modal-title" id="myModalLabel">Modal title</h4>-->
     </div>
     <div class="modal-body text-center">
      <H1>${message}</H1>
     </div>
<!--      <div class="modal-footer">
       <button type="button" class="btn btn-default" data-dismiss="modal">Close</button>
       <button type="button" class="btn btn-primary">Save changes</button>
     </div>-->
   </div>
 </div>
</div>

    </body>
</html>
