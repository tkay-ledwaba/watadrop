from rest_framework.decorators import api_view
from rest_framework.response import Response
from rest_framework.views import APIView
from api.models.orders import Order
from rest_framework import status

from api.serializers.order_serializer import OrderSerializer

class OrderViews(APIView):
    def post(self, request):
        serializer = OrderSerializer(data=request.data)
        if serializer.is_valid():
            serializer.save()
            return Response({"status": "success", "data": serializer.data}, status=status.HTTP_200_OK)
        else:
            return Response({"status": "error", "data": serializer.errors}, status=status.HTTP_400_BAD_REQUEST)
  

@api_view(['GET'])
def getOrders(request):
    orders = Order.objects.all()
    serializer = OrderSerializer(orders, many=True)

    return Response(serializer.data)