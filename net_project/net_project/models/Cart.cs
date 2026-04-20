using System;
using System.Collections.Generic;
using System.Web;

namespace net_project.Models
{
    public class CartItem
    {
        public CartItem() { }

        public CartItem(int itemId, string itemType, string description, decimal unitPrice, int quantity)
        {
            this.ItemId = itemId;
            this.ItemType = itemType;
            this.Description = description;
            this.UnitPrice = unitPrice;
            this.Quantity = quantity;
        }

        public int ItemId { get; set; }
        public string ItemType { get; set; }
        public string Description { get; set; }
        public decimal UnitPrice { get; set; }
        public int Quantity { get; set; }

        public void AddQuantity(int quantity)
        {
            this.Quantity += quantity;
        }

        public string Display()
        {
            return string.Format("{0} ({1} at {2})",
                Description,
                Quantity.ToString(),
                UnitPrice.ToString("c")
            );
        }
    }

    public class CartItemList
    {
        private List<CartItem> cartItems;

        public CartItemList()
        {
            cartItems = new List<CartItem>();
        }

        public int Count
        {
            get { return cartItems.Count; }
        }

        public CartItem this[int index]
        {
            get { return cartItems[index]; }
            set { cartItems[index] = value; }
        }

        public decimal Total
        {
            get
            {
                decimal total = 0;
                foreach (CartItem item in cartItems)
                    total += item.UnitPrice * item.Quantity;
                return total;
            }
        }

        public CartItem GetCartItemById(int id, string itemType)
        {
            foreach (CartItem c in cartItems)
                if (c.ItemId == id && c.ItemType == itemType) return c;
            return null;
        }

        public List<CartItem> GetCartItems()
        {
            return cartItems;
        }

        public static CartItemList GetCart()
        {
            CartItemList cart = (CartItemList)HttpContext.Current.Session["Cart"];
            if (cart == null)
                HttpContext.Current.Session["Cart"] = new CartItemList();
            return (CartItemList)HttpContext.Current.Session["Cart"];
        }

        public void AddItem(int itemId, string itemType, string description, decimal unitPrice, int quantity)
        {
            CartItem existing = GetCartItemById(itemId, itemType);
            if (existing != null)
                existing.AddQuantity(quantity);
            else
                cartItems.Add(new CartItem(itemId, itemType, description, unitPrice, quantity));
        }

        public void RemoveAt(int index)
        {
            cartItems.RemoveAt(index);
        }

        public void RemoveById(int id, string itemType)
        {
            CartItem item = GetCartItemById(id, itemType);
            List<CartItem> aux = GetCartItems();
            int indexAux = aux.IndexOf(item);
            RemoveAt(indexAux);
        }

        public void Clear()
        {
            cartItems.Clear();
        }
    }
}